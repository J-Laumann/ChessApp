//
//  AddPlayerViewController.swift
//  NewspaperExample
//
//  Created by Isaiah on 12/17/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController {

    @IBOutlet weak var FirstNameInput: UITextField!
    @IBOutlet weak var LastNameInput:   UITextField!
    @IBOutlet weak var PlayerFirstName: UILabel!
    @IBOutlet weak var PlayerLastName: UILabel!
    @IBOutlet weak var PlayerPicture: UIImageView!
    @IBOutlet var AddPlayerPicture: UIView!
    
    var players : [Player] = []
    
    @IBAction func CreatePlayer(_ sender: Any) {
        performSegue(withIdentifier: "returnSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: "returnSegue", action:    )
        FirstNameInput.returnKeyType = UIReturnKeyType.done
        LastNameInput.returnKeyType = UIReturnKeyType.done
        
    }

    @IBAction func doneFN(_ sender: UITextField) {
        FirstNameInput.resignFirstResponder()
    }
    
    @IBAction func donLN(_ sender: UITextField) {
        LastNameInput.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnSegue" {
            let dv = segue.destination as? StoriesTableViewController
            dv?.players = players
            dv?.newPlayer(fn: FirstNameInput.text!, ln: LastNameInput.text!)
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

}
