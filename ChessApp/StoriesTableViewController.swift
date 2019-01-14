import UIKit

class StoriesTableViewController: UITableViewController {

    var players : [Player]! = []
    var season : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        season = UserDefaults.standard.integer(forKey: "season")
        //Do stuff NOW
        //self.title = "Season \(Int(season) + 1) Players"
        players = []
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddPlayer))
        if(UserDefaults.standard.integer(forKey: "\(season)players") != 0){
            let playerCount = UserDefaults.standard.integer(forKey: "\(season)players")
            for i in 0...(playerCount - 1){
                players.append(Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi")))
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
    
    func deletePlayer(slot: Int){
        var matches : [HistoryMatch] = []
        var matchCount : Int = UserDefaults.standard.integer(forKey: "\(season)matches")
        if(matchCount > 0){
            for i in 0...(UserDefaults.standard.integer(forKey: "\(season)matches")){
                matches.append(HistoryMatch.init(player: Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi")), oppName: "Place", oppSchool: "Holder", board: 1, result: 1, m: 1, d: 1, y: 1))
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
        for tab in (tabBarController?.viewControllers)!{
            tab.viewDidLoad()
        }
        tableView.reloadData()
    }
    
    func newPlayer(fn: String, ln: String, image: UIImage){
        players.append(Player(fn: fn, ln: ln, img: image))
        players[players.count - 1].archive(fileName: "\(season)player\(players.count - 1)")
        UserDefaults.standard.set(players.count, forKey: "\(season)players")
        tableView.reloadData()
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
            tabBarController?.viewControllers![1].viewDidLoad()
        }
    }
    
    @IBAction func deletePlayerAndUnwind(sender: UIStoryboardSegue){
        if let source = sender.source as? PlayerDetailViewController{
            deletePlayer(slot: source.slot)
        }
    }
}
