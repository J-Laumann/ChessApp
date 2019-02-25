//
//  MainViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/19/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import GoogleAPIClientForREST
import GoogleToolboxForMac
import Google
import GTMOAuth2

//By Jackson Laumann
class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var mainPlayers : [Player]! = []
    var playerCount : Int = 0
    
    private let scopes = [kGTLRAuthScopeSheetsDrive, kGTLRAuthScopeSheetsSpreadsheets]
    private let service = GTLRSheetsService()
    private var auth = GIDAuthentication()
    
    @IBOutlet weak var seasonPicker: UIPickerView!
    
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var schoolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GOOGLE
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        /*if(GIDSignIn.sharedInstance().clientID != nil){
         background.superview?.isHidden = true
         signInButton.isHidden = true
         }
         */
        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        seasonPicker.dataSource = self
        seasonPicker.delegate = self
        goButton.titleLabel?.numberOfLines = 1
        goButton.titleLabel?.adjustsFontSizeToFitWidth = true
        goButton.titleLabel?.lineBreakMode = .byClipping
    
        schoolField.returnKeyType = .done
        if UserDefaults.standard.string(forKey: "school") != nil && UserDefaults.standard.string(forKey: "school") != ""{
            schoolField.text = UserDefaults.standard.string(forKey: "school")
        }
        
        if(UserDefaults.standard.integer(forKey: "players") != 0){
            playerCount = UserDefaults.standard.integer(forKey: "players")
            for i in 0...(playerCount - 1){
                mainPlayers.append(Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""))
                mainPlayers[i].restore(fileName: "player\(i)")
            }
        }
        
        if(UserDefaults.standard.integer(forKey: "season") != 0){
            seasonPicker.selectRow(UserDefaults.standard.integer(forKey: "season"), inComponent: 0, animated: true)
        }
        else{
            seasonPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DoneSchoolField(_ sender: Any) {
        UserDefaults.standard.set(schoolField.text, forKey: "school")
        schoolField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            if let dvc = segue.destination as? TabViewController{
                dvc.season = seasonPicker.selectedRow(inComponent: 0)
                print("\(seasonPicker.selectedRow(inComponent: 0))")
                dvc.auth = auth
                print("SENDING AUTH... ID: \(auth.clientID)")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 99
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 2018) - \(row + 2019)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: "season")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            self.service.authorizer = nil
        } else {
            print("SIGNED IN!")
            background.superview?.isHidden = true
            signInButton.isHidden = true
            print("fuckin scopes work: \(signIn.currentUser.grantedScopes[0])")
            self.service.authorizer = signIn.currentUser.authentication.fetcherAuthorizer()
            //self.service.apiKey = "AIzaSyA3DGxcVr0ZOayrk3KHLtkkrTgz_4zq8MA"
            auth = signIn.currentUser.authentication
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        UserDefaults.standard.set(schoolField.text, forKey: "school")
    }
    
    @IBAction func SignOutPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        signInButton.isHidden = false
        background.superview?.isHidden = false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toMain" {
            if schoolField.text == "" || schoolField.text == nil {
                schoolLabel.textColor = UIColor.red
                return false
            }
        }
        return true
    }
    
}

class BackTabController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "begin", sender: self)
    }
}

class MainPlayerCell : UITableViewCell {
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
}
