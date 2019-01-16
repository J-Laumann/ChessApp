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

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GIDSignInUIDelegate {
    
    var mainPlayers : [Player]! = []
    var playerCount : Int = 0
    
    @IBOutlet weak var seasonPicker: UIPickerView!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        GIDSignIn.sharedInstance().uiDelegate = self
        if(GIDSignIn.sharedInstance() != nil){
            background.superview?.isHidden = true
            signInButton.isHidden = true
        }
        
        seasonPicker.dataSource = self
        seasonPicker.delegate = self
        goButton.titleLabel?.numberOfLines = 1
        goButton.titleLabel?.adjustsFontSizeToFitWidth = true
        goButton.titleLabel?.lineBreakMode = .byClipping
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            if let dvc = segue.destination as? MainTabController{
                dvc.season = seasonPicker.selectedRow(inComponent: 0)
                print("\(seasonPicker.selectedRow(inComponent: 0))")
                dvc.mainPlayers = mainPlayers
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
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: "season")
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("SIGNED IN!")
        background.superview?.isHidden = true
        signInButton.isHidden = true
    }
    
}

class MainTabController : UITabBarController{
    
    var season: Int!
    var mainPlayers : [Player]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //do stuff
    
    }
}

class BackTabController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "begin", sender: self)
    }
}
