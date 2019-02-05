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
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var boardText: UILabel!
    @IBOutlet weak var oppInfo: UILabel!
    @IBOutlet weak var result: UILabel!
    var index : Int!
}

class NewMatchesView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //This ones for making the original six and getting changes
    var newMatch : HistoryMatch!
    @IBOutlet weak var gamesTable: UITableView!
    var matches : [HistoryMatch] = []
    
    var auth : GIDAuthentication!
    var season : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesTable.delegate = self
        gamesTable.dataSource = self
        newMatch = HistoryMatch.init(player: Player.init(fn: "New", ln: "Match", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0)
        matches = [newMatch]
        
        //load match in progress if exists
        let tempMatches = UserDefaults.standard.integer(forKey: "\(season)tempMatches")
        print("TempMatches: \(tempMatches)")
        if tempMatches > 0 {
            for y in 0...(tempMatches-1) {
                matches[y].restore(fileName: "\(season)tempMatch\(y)")
                matches.append(HistoryMatch.init(player: Player.init(fn: "New", ln: "Match", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0))
            }
        }
        print("\(newMatch.opponent)")
        for i in 0...matches.count - 1{
            print("Match \(i): \(matches[i].opponent)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
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
        if matches[indexPath.row].month > 0 {
            cell.dateText.text = "\(matches[indexPath.row].month) / \(matches[indexPath.row].day) / \(matches[indexPath.row].year)"
        }
        else{
            cell.dateText.text = ""
        }
        if matches[indexPath.row].opponent != "" && matches[indexPath.row].opponentSchool != "" {
            cell.oppInfo.text = "\(matches[indexPath.row].opponent) : \(matches[indexPath.row].opponentSchool)"
        }
        else{
            cell.oppInfo.text = ""
        }
        cell.playerName.text = "\(matches[indexPath.row].player.firstName) \(matches[indexPath.row].player.lastName)"
        cell.playerName.textAlignment = .left
        if cell.playerName.text == "New Match" {
            cell.playerName.textAlignment = .center
        }
        if matches[indexPath.row].result == 1 {
            cell.result.text = "L"
        }
        else if matches[indexPath.row].result == 2 {
            cell.result.text = "T"
        }
        else if matches[indexPath.row].result == 0{
            cell.result.text = "W"
        }
        else{
            cell.result.text = ""
        }
        cell.index = indexPath.row
        return cell
    }
    
    @IBAction func setMatch(_ sender: UIStoryboardSegue) {
        if sender.source is NewMatchViewController {
            if let sv = sender.source as? NewMatchViewController {
                if sv.BoardField.text == "" {
                    print("Cancelled match set")
                    return
                }
                sv.SaveMatch()
                let date = sv.datePicker.date
                let x = matches.count - 1
                matches[x].player = sv.player
                matches[x].boardNumb = Int(sv.BoardField.text!)!
                matches[x].day = Calendar.current.component(.day, from: date)
                matches[x].month = Calendar.current.component(.month, from: date)
                matches[x].year = Calendar.current.component(.year, from: date)
                matches[x].opponentSchool = sv.OppSchoolField.text!
                matches[x].opponent = sv.OppNameField.text!
                matches[x].result = sv.result
                matches.append(HistoryMatch.init(player: Player.init(fn: "New", ln: "Match", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0))
                UserDefaults.standard.set(matches.count - 1, forKey: "\(season)tempMatches")
                matches[x].archive(fileName: "\(season)tempMatch\(x)")
                print("New File: \(season)tempMatch\(x)")
                gamesTable.reloadData()
            }
        }
    }
    
    @IBAction func FinishMatches(_ sender: Any) {
        matches = [HistoryMatch.init(player: Player.init(fn: "New", ln: "Match", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: -1, result: 6, m: 0, d: 0, y: 0)]
        UserDefaults.standard.set(0, forKey: "\(season)tempMatches")
        gamesTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send just the index
        if segue.identifier == "toSetMatch" {
            let button = sender as? NewMatchTableCell
            let detailView = segue.destination as? NewMatchViewController
            detailView?.auth = auth
            detailView?.gameIndex = button?.index
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toSetMatch" {
            if let cell = sender as? NewMatchTableCell {
                if cell.index < (matches.count - 1) {
                    return false
                }
            }
            else{
                print("couldnt get cell!!")
            }
        }
        return true
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
    
    //Lotsa Motza! SIKE ITS UI
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var playerPicker: UIPickerView!
    
    @IBOutlet weak var OppNameField: UITextField!
    @IBOutlet weak var OppSchoolField: UITextField!
    @IBOutlet weak var BoardField: UITextField!
    
    @IBOutlet weak var WinButton: UIButton!
    @IBOutlet weak var LossButton: UIButton!
    @IBOutlet weak var TieButton: UIButton!
    
    @IBOutlet weak var popupView: UIImageView!
    @IBOutlet weak var popupText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        season = UserDefaults.standard.integer(forKey: "season")
        // Do any additional setup after loading the view.
        //self.title = "New Season \(Int(season) + 1) Match"
        if(pickedColor == nil && noColor == nil){
            pickedColor = #imageLiteral(resourceName: "curved2")
            noColor = #imageLiteral(resourceName: "curved")
        }
        WinButton.setTitleColor(.green, for: .normal)
        LossButton.setTitleColor(.red, for: .normal)
        
        
        OppNameField.returnKeyType = UIReturnKeyType.done
        OppSchoolField.returnKeyType = UIReturnKeyType.done
        BoardField.returnKeyType = UIReturnKeyType.done
        BoardField.keyboardType = UIKeyboardType.numberPad
        addDoneButtonToField()
        
        playerPicker.dataSource = self
        playerPicker.delegate = self
        
        if(UserDefaults.standard.integer(forKey: "\(season)players") > 0){
            playerPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        matches = UserDefaults.standard.integer(forKey: "\(season)matches")
        
        if (matches > 0){
            for i in 0...(UserDefaults.standard.integer(forKey: "\(season)matches") - 1){
                matchHistory.append(HistoryMatch.init(player: Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "Place", oppSchool: "Holder", board: 1, result: 1, m: 1, d: 1, y: 1))
                matchHistory[i].restore(fileName: "\(season)match\(i)")
            }
        }
        ChooseTie(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ChooseWin(_ sender: Any) {
        result = 0
        WinButton.setBackgroundImage(pickedColor, for: .normal)
        LossButton.setBackgroundImage(noColor, for: .normal)
        TieButton.setBackgroundImage(noColor, for: .normal)
    }
    
    @IBAction func ChooseLoss(_ sender: Any) {
        result = 1
        WinButton.setBackgroundImage(noColor, for: .normal)
        LossButton.setBackgroundImage(pickedColor, for: .normal)
        TieButton.setBackgroundImage(noColor, for: .normal)
    }
    
    @IBAction func ChooseTie(_ sender: Any) {
        result = 2
        WinButton.setBackgroundImage(noColor, for: .normal)
        LossButton.setBackgroundImage(noColor, for: .normal)
        TieButton.setBackgroundImage(pickedColor, for: .normal)
    }
    
    func addDoneButtonToField(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.BoardField.inputAccessoryView = doneToolbar
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
    
    @IBAction func DoneOppS(_ sender: Any) {
        OppSchoolField.resignFirstResponder()
    }
    
    @IBAction func DoneBoard(_ sender: Any) {
        BoardField.resignFirstResponder()
    }
    
    @objc func doneButtonAction()
    {
        self.BoardField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        player.restore(fileName: "\(season)player\(row)")
        return "\(player.firstName) \(player.lastName)"
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
    
    func SaveMatch() {
        if(BoardField.text != "" && player.sheetID != ""){
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
            let date = self.datePicker.date
            var resultText = "?"
            var pointsText = "0"
            if result == 0 {
                resultText = "W"
                if(Int(BoardField.text!)! < 6){
                    pointsText = "\(21 - Int(BoardField.text!)!)"
                }
                else if(Int(BoardField.text!)! == 6){
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
                if(Int(BoardField.text!)! < 6){
                    pointsText = "\(10.5 - Double(Double(Int(BoardField.text!)!) * 0.5))"
                }
                else if(Int(BoardField.text!)! == 6){
                    pointsText = "5"
                }
                else{
                    pointsText = "0"
                }
            }
            resource.values = [
                [
                    "\(player.history.count + 1)",
                    "\(Calendar.current.component(.month, from: date))/\(Calendar.current.component(.day, from: date))/\(Calendar.current.component(.year, from: date))",
                    "\(Int(BoardField.text!) ?? 0)", "W",
                    "\(OppNameField.text!)",
                    "\(OppSchoolField.text!)",
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
                if(self.BoardField.text != "" && UserDefaults.standard.integer(forKey: "\(self.season)players") > 0){
                    self.player.restore(fileName: "\(self.season)player\(self.playerPicker.selectedRow(inComponent: 0))")
                    let calendar = Calendar.current
                    self.player.history.append(Match.init(oppName: self.OppNameField.text!, oppSchool: self.OppSchoolField.text!, board: Int(self.BoardField.text!)!, result: self.result , m: calendar.component(.month, from: date), d: calendar.component(.day, from: date), y: calendar.component(.year, from: date), id: self.matches))
                    self.matchHistory.append(HistoryMatch.init(player: self.player, oppName: self.OppNameField.text!, oppSchool: self.OppSchoolField.text!, board: Int(self.BoardField.text!)!, result: self.result , m: calendar.component(.month, from: date), d: calendar.component(.day, from: date), y: calendar.component(.year, from: date)))
                    self.matches = self.matchHistory.count
                    self.matchHistory[self.matches - 1].archive(fileName: "\(self.season)match\(self.matchHistory[self.matches - 1])")
                    UserDefaults.standard.set(self.matches, forKey: "\(self.season)matches")
                    self.player.archive(fileName: "\(self.season)player\(self.playerPicker.selectedRow(inComponent: 0))")
                    self.saveHistory()
                    self.ChooseTie(self)
                    self.OppSchoolField.text = ""
                    self.OppNameField.text = ""
                    self.BoardField.text = ""
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
