//
//  MainViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/19/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

struct Match {
    var opponent : String
    var opponentSchool : String
    var boardNumb : Int
    //result - 0 = win, 1 = loss, 2 = tie
    var result : Int
}
struct Player {
    
    var id : Int
    var firstName: String
    var lastName: String
    var image : UIImage
    var history : [Match]
}

class MainViewController: UIViewController {
    
    var exampleMatches = [
        Match(opponent: "Mud Mud", opponentSchool: "Rosemount", boardNumb: 1, result: 0)
    ]
    
    var mainPlayers : [Player]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainPlayers = [
            Player(id: 1, firstName: "Jackson", lastName: "Laumann", image: #imageLiteral(resourceName: "IMG_0305"),
                   history: [exampleMatches[0]]),
            Player(id: 2, firstName: "Islaya", lastName: "Milbank", image: #imageLiteral(resourceName: "IMG_0329"),
                   history: [exampleMatches[0]]),
            Player(id: 3, firstName: "Mud", lastName: "Mud", image: #imageLiteral(resourceName: "IMG_1811"),
                   history: [])
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teamSegue" {
            let detailView = segue.destination as? StoriesTableViewController
            if let dvc = detailView {
                dvc.players = mainPlayers
            }
        }
    }

}
