//
//  NewMatchViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 1/8/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import AudioToolbox
import GoogleAPIClientForREST
import GoogleSignIn
import GoogleToolboxForMac
import Google
import GTMOAuth2

class NewMatchTableCell: UITableViewCell {
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var boardText: UILabel!
    @IBOutlet weak var lossButton: UIButton!
    @IBOutlet weak var tieButton: UIButton!
    @IBOutlet weak var winButton: UIButton!
    @IBOutlet weak var colorIcon: UIImageView!
    var index : Int!
}

class NewMatchesView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //This ones for making the original six and getting changes
    var newMatch : HistoryMatch!
    @IBOutlet weak var gamesTable: UITableView!
    var matches : [HistoryMatch] = []
    var matchHistory : [HistoryMatch] = []
    
    var auth : GIDAuthentication!
    var service = GTLRSheetsService()
    var season : Int!
    
    //stuff to disable upon new match
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var oppSchoolField: UITextField!
    @IBOutlet weak var newMatchLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesTable.delegate = self
        gamesTable.dataSource = self
        gamesTable.allowsMultipleSelectionDuringEditing = false
        newMatch = HistoryMatch.init(player: Player.init(fn: "New", ln: "Game", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0, color: -1)
        matches = [newMatch]
        oppSchoolField.returnKeyType = .done
        
        //load match in progress if exists
        let tempMatches = UserDefaults.standard.integer(forKey: "\(season)tempMatches")
        print("TempMatches: \(tempMatches)")
        if tempMatches > 0 {
            backgroundImage.isHidden = true
            newMatchLabel.isHidden = true
            oppSchoolField.isHidden = true
            startButton.isHidden = true
            datePicker.isHidden = true
            for y in 0...(tempMatches-1) {
                matches[y].restore(fileName: "\(season)tempMatch\(y)")
                matches.append(HistoryMatch.init(player: Player.init(fn: "New", ln: "Game", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0, color: -1))
            }
        }
        print("\(newMatch.opponent)")
        for i in 0...matches.count - 1{
            print("Match \(i): \(matches[i].opponent)")
        }
        
        let matchAmount = UserDefaults.standard.integer(forKey: "\(season)matches")
        
        if (matchAmount > 0){
            for i in 0...(UserDefaults.standard.integer(forKey: "\(season)matches") - 1){
                matchHistory.append(HistoryMatch.init(player: Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "Place", oppSchool: "Holder", board: 1, result: 1, m: 1, d: 1, y: 1, color: -1))
                matchHistory[i].restore(fileName: "\(season)match\(i)")
            }
        }
    }
    
    @IBAction func tiePressed(_ sender: Any) {
        if let button = sender as? UIButton {
            print("Pressed tie: \(button.tag)")
            matches[button.tag].result = 2
            matches[button.tag].archive(fileName: "\(season)tempMatch\(button.tag)")
            gamesTable.reloadData()
        }
    }
    @IBAction func lossPressed(_ sender: Any) {
        if let button = sender as? UIButton {
            print("Pressed lose: \(button.tag)")
            matches[button.tag].result = 1
            matches[button.tag].archive(fileName: "\(season)tempMatch\(button.tag)")
            gamesTable.reloadData()
        }
    }
    @IBAction func winPressed(_ sender: Any) {
        if let button = sender as? UIButton {
            print("Pressed win: \(button.tag)")
            matches[button.tag].result = 0
            matches[button.tag].archive(fileName: "\(season)tempMatch\(button.tag)")
            gamesTable.reloadData()
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        matches = [HistoryMatch.init(player: Player.init(fn: "New", ln: "Game", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0, color: -1)]
        UserDefaults.standard.set(0, forKey: "\(season)tempMatches")
        UserDefaults.standard.set("", forKey: "\(season)tempSchool")
        gamesTable.reloadData()
        backgroundImage.isHidden = false
        newMatchLabel.isHidden = false
        oppSchoolField.text = ""
        oppSchoolField.isHidden = false
        startButton.isHidden = false
        datePicker.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            matches.remove(at: indexPath.row)
            if indexPath.row < (matches.count - 1) {
                for i in indexPath.row...(matches.count - 2) {
                    matches[i].boardNumb = i + 1
                    if matches[i].color == 0{
                        matches[i].color = 1
                    }
                    else if matches[i].color == 1 {
                        matches[i].color = 0
                    }
                }
            }
            gamesTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == matches.count {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newMatchCell", for: indexPath) as! NewMatchTableCell
        print("\(matches[indexPath.row].opponent)")
        if matches[indexPath.row].boardNumb >= 0{
            cell.boardText.text = "\(matches[indexPath.row].boardNumb)"
            cell.selectionStyle = .none
        }
        else{
            cell.boardText.text = ""
            cell.selectionStyle = .default
        }
        if matches[indexPath.row].color == 0 {
            cell.colorIcon.image = #imageLiteral(resourceName: "whiteKing")
        }
        else if matches[indexPath.row].color == 1 {
            cell.colorIcon.image = #imageLiteral(resourceName: "blackKing")
        }
        else {
            cell.colorIcon.image = #imageLiteral(resourceName: "plussign")
        }
        cell.playerName.text = "\(matches[indexPath.row].player.firstName) \(matches[indexPath.row].player.lastName) vs. \(matches[indexPath.row].opponent)"
        cell.playerName.textAlignment = .left
        cell.lossButton.isHidden = false
        cell.tieButton.isHidden = false
        cell.winButton.isHidden = false
        if cell.playerName.text == "New Game vs. " {
            cell.playerName.textAlignment = .center
            cell.playerName.text = "\(matches[indexPath.row].player.firstName) \(matches[indexPath.row].player.lastName)"
            cell.lossButton.isHidden = true
            cell.tieButton.isHidden = true
            cell.winButton.isHidden = true
        }
        if matches[indexPath.row].result == 0 {
            cell.winButton.setBackgroundImage(#imageLiteral(resourceName: "curved2"), for: .normal)
            cell.lossButton.setBackgroundImage(#imageLiteral(resourceName: "curved"), for: .normal)
            cell.tieButton.setBackgroundImage(#imageLiteral(resourceName: "curved"), for: .normal)
        }
        else if matches[indexPath.row].result == 1 {
            cell.winButton.setBackgroundImage(#imageLiteral(resourceName: "curved"), for: .normal)
            cell.lossButton.setBackgroundImage(#imageLiteral(resourceName: "curved2"), for: .normal)
            cell.tieButton.setBackgroundImage(#imageLiteral(resourceName: "curved"), for: .normal)
        }
        else if matches[indexPath.row].result == 2 {
            cell.winButton.setBackgroundImage(#imageLiteral(resourceName: "curved"), for: .normal)
            cell.lossButton.setBackgroundImage(#imageLiteral(resourceName: "curved"), for: .normal)
            cell.tieButton.setBackgroundImage(#imageLiteral(resourceName: "curved2"), for: .normal)
        }
        cell.lossButton.tag = indexPath.row
        cell.winButton.tag = indexPath.row
        cell.tieButton.tag = indexPath.row
        cell.index = indexPath.row
        return cell
    }
    
    @IBAction func setMatch(_ sender: UIStoryboardSegue) {
        if sender.source is NewMatchViewController {
            if let sv = sender.source as? NewMatchViewController {
                if sv.OppNameField.text == "" {
                    print("Cancelled match set")
                    return
                }
                let x = matches.count - 1
                matches[x].player = sv.player
                matches[x].boardNumb = sv.gameIndex + 1
                matches[x].day = UserDefaults.standard.integer(forKey: "\(season)tempDay")
                matches[x].month = UserDefaults.standard.integer(forKey: "\(season)tempMonth")
                matches[x].year = UserDefaults.standard.integer(forKey: "\(season)tempYear")
                matches[x].opponentSchool = UserDefaults.standard.string(forKey: "\(season)tempSchool")!
                matches[x].opponent = sv.OppNameField.text!
                matches[x].result = sv.result
                matches[x].color = sv.gameColor
                matches.append(HistoryMatch.init(player: Player.init(fn: "New", ln: "Game", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0, color: -1))
                UserDefaults.standard.set(matches.count - 1, forKey: "\(season)tempMatches")
                matches[x].archive(fileName: "\(season)tempMatch\(x)")
                print("New File: \(season)tempMatch\(x)")
                gamesTable.reloadData()
            }
        }
    }
    
    @IBAction func FinishMatches(_ sender: Any) {
        //save all to players
        for match in matches {
            SaveMatch(match: Match.init(oppName: match.opponent, oppSchool: match.opponentSchool, board: match.boardNumb, result: match.result, m: match.month, d: match.day, y: match.year, id: match.player.history.count - 1, color: match.color), player: match.player)
        }
        //reset
        matches = [HistoryMatch.init(player: Player.init(fn: "New", ln: "Game", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0, color: -1)]
        UserDefaults.standard.set(0, forKey: "\(season)tempMatches")
        UserDefaults.standard.set("", forKey: "\(season)tempSchool")
        gamesTable.reloadData()
        backgroundImage.isHidden = false
        newMatchLabel.isHidden = false
        oppSchoolField.text = ""
        oppSchoolField.isHidden = false
        startButton.isHidden = false
        datePicker.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send just the index
        if segue.identifier == "toSetMatch" {
            let button = sender as? NewMatchTableCell
            let detailView = segue.destination as? NewMatchViewController
            detailView?.auth = auth
            detailView?.gameIndex = button?.index
            if (button?.index)! > 0 {
                detailView?.firstColor = matches[0].color
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toSetMatch" {
            if let cell = sender as? NewMatchTableCell {
                if cell.index < (matches.count - 1) || UserDefaults.standard.string(forKey: "\(season)tempSchool") == "" || UserDefaults.standard.string(forKey: "\(season)tempSchool") == nil{
                    if UserDefaults.standard.string(forKey: "\(season)tempSchool") == "" || UserDefaults.standard.string(forKey: "\(season)tempSchool") == nil {
                        matches = [HistoryMatch.init(player: Player.init(fn: "New", ln: "Game", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0, color: -1)]
                        UserDefaults.standard.set(0, forKey: "\(season)tempMatches")
                        UserDefaults.standard.set("", forKey: "\(season)tempSchool")
                        gamesTable.reloadData()
                        backgroundImage.isHidden = false
                        newMatchLabel.isHidden = false
                        oppSchoolField.isHidden = false
                        startButton.isHidden = false
                        datePicker.isHidden = false
                    }
                    return false
                }
            }
            else{
                print("couldnt get cell!!")
            }
        }
        return true
    }
    
    @IBAction func StartMatch(_ sender: Any) {
        backgroundImage.isHidden = true
        newMatchLabel.isHidden = true
        UserDefaults.standard.set(oppSchoolField.text, forKey: "\(season)tempSchool")
        oppSchoolField.isHidden = true
        startButton.isHidden = true
        let date = datePicker.date
        UserDefaults.standard.set(Calendar.current.component(.day, from: date), forKey: "\(season)tempDay")
        UserDefaults.standard.set(Calendar.current.component(.month, from: date), forKey: "\(season)tempMonth")
        UserDefaults.standard.set(Calendar.current.component(.year, from: date), forKey: "\(season)tempYear")
        datePicker.isHidden = true
    }
    
    @IBAction func doneSchool(_ sender: Any) {
        oppSchoolField.resignFirstResponder()
    }
    
    func SaveMatch(match: Match, player: Player){
        //SAVE ANY MATCH TO A PLAYER
        if player.sheetID != "" {
            let resource = GTLRSheets_ValueRange.init()
            service.authorizer = auth.fetcherAuthorizer()
            var resultText = "?"
            var pointsText = "0"
            let result = match.result
            var colorText = "W"
            if match.color == 0 {
                colorText = "White"
            }
            else {
                colorText = "Black"
            }
            if result == 0 {
                resultText = "W"
                if(match.boardNumb < 6){
                    pointsText = "\(21 - match.boardNumb)"
                }
                else if(match.boardNumb == 6){
                    pointsText = "10"
                }
                else{
                    pointsText = "0"
                }
            }
            else if result == 1 {
                resultText = "L"
            }
            else{
                resultText = "T"
                if(match.boardNumb < 6){
                    pointsText = "\(10.5 - Double(Double(match.boardNumb) * 0.5))"
                }
                else if(match.boardNumb == 6){
                    pointsText = "5"
                }
                else{
                    pointsText = "0"
                }
            }
            resource.values = [
                [
                    "\(player.history.count + 1)",
                    "\(match.month)/\(match.day)/\(match.year)",
                    "\(match.boardNumb)",
                    "\(colorText)",
                    "\(match.opponent)",
                    "\(match.opponentSchool)",
                    "\(resultText)",
                    "\(pointsText)"
                ]
            ]
            let spreadsheetId = player.sheetID
            let range = "A\(16 + player.history.count):H\(16 + player.history.count)"
            resource.range = range
            let editQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: resource, spreadsheetId: spreadsheetId, range: range)
            editQuery.valueInputOption = "RAW"
            editQuery.insertDataOption = "OVERWRITE"
            editQuery.completionBlock = { (ticket, result, NSError) in
                if(UserDefaults.standard.integer(forKey: "\(self.season)players") > 0){
                    let tempPlayer = Player.init(fn: "New", ln: "Game", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: "")
                    tempPlayer.restore(fileName: "\(self.season)player\(player.index)")
                    tempPlayer.history.append(Match.init(oppName: match.opponent, oppSchool: match.opponentSchool, board: match.boardNumb, result: match.result, m: match.month, d: match.day, y: match.year, id: UserDefaults.standard.integer(forKey:"\(self.season)matches"), color: match.color))
                    self.matchHistory.append(HistoryMatch.init(player: player, oppName: match.opponent, oppSchool: match.opponentSchool, board: match.boardNumb, result: match.result, m: match.month, d: match.day, y: match.year, color: match.color))
                    self.matchHistory[UserDefaults.standard.integer(forKey:"\(self.season)matches")].archive(fileName: "\(self.season)match\(UserDefaults.standard.integer(forKey:"\(self.season)matches"))")
                    print("Saved Match history under \(self.season)match\(UserDefaults.standard.integer(forKey:"\(self.season)matches"))")
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey:"\(self.season)matches") + 1, forKey: "\(self.season)matches")
                    tempPlayer.archive(fileName: "\(self.season)player\(player.index)")
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
            service.executeQuery(editQuery, completionHandler: nil)
        }
    }
    
}

class NewMatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    //This ones for changing the new matches
    var result = 2
    var pickedColor : UIImage!
    var noColor : UIImage!
    
    var timer : Timer!
    
    var season : Int!
    var player : Player = Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID:"")
    
    private let service = GTLRSheetsService()
    var auth : GIDAuthentication!
    
    var matchHistory : [HistoryMatch] = []
    var matches : Int = 0
    var gameIndex : Int!
    var gameColor : Int = 0
    var firstColor : Int!
    
    //Lotsa Motza! SIKE ITS UI
    @IBOutlet weak var playerPicker: UIPickerView!
    
    @IBOutlet weak var OppNameField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var colorTip: UILabel!
    
    @IBOutlet weak var popupView: UIImageView!
    @IBOutlet weak var popupText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gameIndex > 0 {
            colorButton.isHidden = true
            colorTip.isHidden = true
            print("\(firstColor)")
            if firstColor == 0{
                //white first
                gameColor = firstColor + (gameIndex+2).remainderReportingOverflow(dividingBy: 2).partialValue
            }
            else if firstColor == 1{
                //black first
                gameColor = firstColor - (gameIndex+2).remainderReportingOverflow(dividingBy: 2).partialValue
            }
        }
        season = UserDefaults.standard.integer(forKey: "season")
        // Do any additional setup after loading the view.
        //self.title = "New Season \(Int(season) + 1) Match"
        if(pickedColor == nil && noColor == nil){
            pickedColor = #imageLiteral(resourceName: "curved2")
            noColor = #imageLiteral(resourceName: "curved")
        }
        
        
        OppNameField.returnKeyType = UIReturnKeyType.done
        
        playerPicker.dataSource = self
        playerPicker.delegate = self
        
        if(UserDefaults.standard.integer(forKey: "\(season)players") > 0){
            playerPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        matches = UserDefaults.standard.integer(forKey: "\(season)matches")
        
        if (matches > 0){
            for i in 0...(UserDefaults.standard.integer(forKey: "\(season)matches") - 1){
                matchHistory.append(HistoryMatch.init(player: Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "Place", oppSchool: "Holder", board: 1, result: 1, m: 1, d: 1, y: 1, color: 0))
                matchHistory[i].restore(fileName: "\(season)match\(i)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UserDefaults.standard.integer(forKey: "\(season)players")
    }
    
    @IBAction func DoneOppN(_ sender: Any) {
        OppNameField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        player.restore(fileName: "\(season)player\(row)")
        return "\(player.firstName) \(player.lastName)"
    }
    
    @IBAction func colorSwap(_ sender: Any) {
        if gameColor == 0 {
            colorButton.setImage(#imageLiteral(resourceName: "blackKing"), for: .normal)
            gameColor = 1
        }
        else {
            colorButton.setImage(#imageLiteral(resourceName: "whiteKing"), for: .normal)
            gameColor = 0
        }
    }
    
    @objc func hidePopup() {
        popupView.alpha -= CGFloat(timer.timeInterval)
        popupText.alpha -= CGFloat(timer.timeInterval)
        if(popupView.alpha <= 0){
            popupText.isHidden = true
            popupView.isHidden = true
            timer.invalidate()
        }
    }
    
    @objc func wait(){
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: (#selector(self.hidePopup)), userInfo: nil, repeats: true)
    }
    
    func saveHistory(){
        UserDefaults.standard.set(matches, forKey: "\(season)matches")
        for i in 0...(matchHistory.count - 1){
            matchHistory[i].archive(fileName: "\(season)match\(i)")
        }
    }
    
    func SaveMatch(match : Match, player : Player) {
        if(player.sheetID != ""){
            print("Saving match...")
            popupText.text = "Saving Match..."
            //let button = sender as? UIButton
            //button?.isEnabled = false
            popupText.isHidden = false
            popupView.isHidden = false
            popupView.alpha = 1
            popupText.alpha = 1
            let resource = GTLRSheets_ValueRange.init()
            service.authorizer = auth.fetcherAuthorizer()
            var resultText = "?"
            var pointsText = "0"
            result = match.result
            var colorText = "W"
            if gameColor == 0 {
                colorText = "White"
            }
            else {
                colorText = "Black"
            }
            if result == 0 {
                resultText = "W"
                if(match.boardNumb < 6){
                    pointsText = "\(21 - match.boardNumb)"
                }
                else if(match.boardNumb == 6){
                    pointsText = "10"
                }
                else{
                    pointsText = "0"
                }
            }
            else if result == 1 {
                resultText = "L"
            }
            else{
                resultText = "T"
                if(match.boardNumb < 6){
                    pointsText = "\(10.5 - Double(Double(match.boardNumb) * 0.5))"
                }
                else if(match.boardNumb == 6){
                    pointsText = "5"
                }
                else{
                    pointsText = "0"
                }
            }
            resource.values = [
                [
                    "\(player.history.count + 1)",
                    "\(match.month)/\(match.day)/\(match.year)",
                    "\(match.boardNumb)",
                    "\(colorText)",
                    "\(match.opponent)",
                    "\(match.opponentSchool)",
                    "\(resultText)",
                    "\(pointsText)"
                ]
            ]
            let spreadsheetId = player.sheetID
            let range = "A\(16 + player.history.count):H\(16 + player.history.count)"
            resource.range = range
            let editQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: resource, spreadsheetId: spreadsheetId, range: range)
            editQuery.valueInputOption = "RAW"
            editQuery.insertDataOption = "OVERWRITE"
            editQuery.completionBlock = { (ticket, result, NSError) in
                if(UserDefaults.standard.integer(forKey: "\(self.season)players") > 0){
                    self.player.restore(fileName: "\(self.season)player\(self.playerPicker.selectedRow(inComponent: 0))")
                    self.player.history.append(Match.init(oppName: match.opponent, oppSchool: match.opponentSchool, board: match.boardNumb, result: match.result, m: match.month, d: match.day, y: match.year, id: self.matches, color: self.gameColor))
                    self.matchHistory.append(HistoryMatch.init(player: player, oppName: match.opponent, oppSchool: match.opponent, board: match.boardNumb, result: match.result, m: match.month, d: match.day, y: match.year, color: self.gameColor))
                    self.matchHistory[self.matches - 1].archive(fileName: "\(self.season)match\(self.matchHistory[self.matches - 1])")
                    UserDefaults.standard.set(self.matches, forKey: "\(self.season)matches")
                    self.player.archive(fileName: "\(self.season)player\(self.playerPicker.selectedRow(inComponent: 0))")
                    self.saveHistory()
                    self.OppNameField.text = ""
                    self.playerPicker.selectRow(0, inComponent: 0, animated: true)
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.wait)), userInfo: nil, repeats: false)
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.popupView.isHidden = false
                    self.popupText.isHidden = false
                    self.popupText.text = "Match Saved!"
                    self.popupView.alpha = 1
                    self.popupText.alpha = 1
                }
            }
            service.executeQuery(editQuery, completionHandler: nil)
        }
    }
}
