//
//  NewMatchViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 1/8/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import AudioToolbox

class NewMatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    var result = 2
    var pickedColor : UIImage!
    var noColor : UIImage!
    
    var timer : Timer!
    
    var season : Int!
    var player : Player = Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID:"")
    
    var matchHistory : [HistoryMatch] = []
    var matches : Int = 0
    
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
    
    @IBAction func SaveMatch(_ sender: Any) {
        if(BoardField.text != "" && UserDefaults.standard.integer(forKey: "\(season)players") > 0){
            player.restore(fileName: "\(season)player\(playerPicker.selectedRow(inComponent: 0))")
            let calendar = Calendar.current
            let date = datePicker.date
            player.history.append(Match.init(oppName: OppNameField.text!, oppSchool: OppSchoolField.text!, board: Int(BoardField.text!)!, result: result, m: calendar.component(.month, from: date), d: calendar.component(.day, from: date), y: calendar.component(.year, from: date), id: matches))
            matchHistory.append(HistoryMatch.init(player: player, oppName: OppNameField.text!, oppSchool: OppSchoolField.text!, board: Int(BoardField.text!)!, result: result, m: calendar.component(.month, from: date), d: calendar.component(.day, from: date), y: calendar.component(.year, from: date)))
            matches = matchHistory.count
            player.archive(fileName: "\(season)player\(playerPicker.selectedRow(inComponent: 0))")
            saveHistory()
            ChooseTie(self)
            OppSchoolField.text = ""
            OppNameField.text = ""
            BoardField.text = ""
            playerPicker.selectRow(0, inComponent: 0, animated: true)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.wait)), userInfo: nil, repeats: false)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            popupView.isHidden = false
            popupText.isHidden = false
            popupView.alpha = 1
            popupText.alpha = 1
        }
    }
}
