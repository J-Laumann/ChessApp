import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GoogleToolboxForMac
import Google
import GTMOAuth2

class StoriesTableViewController: UITableViewController {

    var players : [Player]! = []
    var season : Int!
    
    private let service = GTLRSheetsService()
    var auth : GIDAuthentication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        season = UserDefaults.standard.integer(forKey: "season")
        //print("\(GIDSignIn.sharedInstance().clientID)")
        // = GIDSignIn.sharedInstance().clientID
        //auth.startSigningIn()
        //Do stuff NOW
        //self.title = "Season \(Int(season) + 1) Players"
        players = []
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableView.allowsMultipleSelectionDuringEditing = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddPlayer))
        if(UserDefaults.standard.integer(forKey: "\(season)players") != 0){
            let playerCount = UserDefaults.standard.integer(forKey: "\(season)players")
            for i in 0...(playerCount - 1){
                players.append(Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""))
                players[i].restore(fileName: "\(season)player\(i)")
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    @objc func openAddPlayer(){
        performSegue(withIdentifier: "addPlayerSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deletePlayer(slot: indexPath.row)
        }
    }
    
    func deletePlayer(slot: Int){
        var matches : [HistoryMatch] = []
        var matchCount : Int = UserDefaults.standard.integer(forKey: "\(season)matches")
        if(matchCount > 0){
            for i in 0...(UserDefaults.standard.integer(forKey: "\(season)matches")){
                matches.append(HistoryMatch.init(player: Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "Place", oppSchool: "Holder", board: 1, result: 1, m: 1, d: 1, y: 1, color: -1))
                matches[i].restore(fileName: "\(season)match\(i)")
            }
        }
        for match in players[slot].history{
            matches.remove(at: match.id)
            matchCount -= 1
        }
        if(matchCount > 0){
            for i in 0...(matchCount - 1){
                matches[i].archive(fileName: "\(season)match\(i)")
            }
        }
        players.remove(at: slot)
        if(players.count > 0){
            for i in 0...(players.count - 1){
                players[i].archive(fileName: "\(season)player\(i)")
            }
        }
        UserDefaults.standard.set(matchCount, forKey: "\(season)matches")
        UserDefaults.standard.set(players.count, forKey: "\(season)players")
        tableView.reloadData()
    }
    
    func newPlayer(fn: String, ln: String, image: UIImage){
        //make a new sheet and get and save its ID
        let tempSheet = GTLRSheets_Spreadsheet.init()
        let newProps = GTLRSheets_SpreadsheetProperties.init()
        newProps.title = "\(fn) \(ln)'s Chess Player Sheet (\(2018+season)-\(2019+season))"
        tempSheet.properties = newProps
        players.append(Player(fn: fn, ln: ln, img: image, shtID: ""))
        let query = GTLRSheetsQuery_SpreadsheetsCreate.query(withObject: tempSheet)
        service.authorizer = auth.fetcherAuthorizer()
        query.completionBlock = { (ticket, result, NSError) in
            
            if let error = NSError {
                print("ERROR:\(error.localizedDescription)")
            }
            else {
                let resultSheet = result as? GTLRSheets_Spreadsheet
                print("Created Sheet! \(String(describing: resultSheet?.properties?.title))")
                let response = result as! GTLRSheets_Spreadsheet
                let resource = GTLRSheets_ValueRange.init()
                resource.values = [
                    ["CHESS LEAGUE"],
                    ["","","","","","","","\(Int(self.season + 2018)) - \(Int(self.season + 2019)) SEASON"],
                    ["Individual Player's Record"],
                    [""],
                    ["Player:", "\(fn) \(ln)"],
                    ["School:", "\(String(describing: UserDefaults.standard.string(forKey: "school")!))", "", "", "", "", "Win", "Draw"],
                    ["","","","","","1st","20","10"],
                    ["","","","","","2nd","19","9.5"],
                    ["","","","","","3rd","18","9"],
                    ["","","","","","4th","17","8.5"],
                    ["","","","","","5th","16","8"],
                    ["","","","","","6th","10","5"],
                    [""],
                    ["ROUND", "DATE", "BOARD", "COLOR", "OPPONENT", "OPP. SCHOOL", "RESULT", "POINTS"]
                ]
                let spreadsheetId = response.spreadsheetId
                let range = "A1:H14"
                let editQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: resource, spreadsheetId: spreadsheetId!, range: range)
                editQuery.valueInputOption = "USER_ENTERED"
                editQuery.completionBlock = { (ticket, result, NSError) in
                    
                    if let error = NSError {
                        print("ERROR:\(error.localizedDescription)")
                    }
                    else {
                        print("Template set...?")
                        let identifier = response.spreadsheetId
                        print("new sheet id: \(identifier!)")
                        self.players[self.players.count - 1].sheetID = String(identifier!)
                        self.players[self.players.count - 1].archive(fileName: "\(self.season)player\(self.players.count - 1)")
                        UserDefaults.standard.set(self.players.count, forKey: "\(self.season)players")
                        self.tableView.reloadData()
                    }
                }
                self.service.executeQuery(editQuery, completionHandler: nil)
            }
        }
        service.executeQuery(query, completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playerSegue" {
            viewDidLoad()
            let detailView = segue.destination as? PlayerDetailViewController
            let cell = sender as! UITableViewCell
            if let dvc = detailView {
                dvc.player =  players[cell.tag - 1]
                dvc.slot = cell.tag - 1
                dvc.season = season
                dvc.auth = auth
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        let h = players[indexPath.row]
        cell.textLabel?.text = "\(h.firstName) \(h.lastName)"
        let strBase64: String = h.imgData
        let dataDecoded: Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        cell.imageView?.image = UIImage(data: dataDecoded)
        cell.tag = indexPath.row + 1

        return cell
    }
    
    @IBAction func unwindToTable(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddPlayerViewController {
            newPlayer(fn: sourceViewController.FirstNameInput.text!, ln: sourceViewController.LastNameInput.text!, image: sourceViewController.PlayerPicture.image!)
            sourceViewController.FirstNameInput.text = ""
            sourceViewController.LastNameInput.text = ""
            sourceViewController.PlayerPicture.image = #imageLiteral(resourceName: "avatar-male-silhouette-hi")
        }
    }
    
    @IBAction func deletePlayerAndUnwind(sender: UIStoryboardSegue){
        if let source = sender.source as? PlayerDetailViewController{
            deletePlayer(slot: source.slot)
        }
    }
}
