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
//I suck big cocks. - Isaiah
//Also I am a libtard.
struct Player {
    
    var id : Int
    var firstName: String
    var lastName: String
    var wins: Int
    var ties: Int
    var losses: Int
    var score: Double
    var image : UIImage
    var history : [Match]
}

class MainViewController: UIViewController {
    
    var exampleMatches = [
        Match(opponent: "Mud Mud", opponentSchool: "Hell", boardNumb: 1, result: 0)
    ]
    
    var mainPlayers : [Player]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainPlayers = [
            Player(id: 1, firstName: "Jackson", lastName: "Laumann",
                   wins: 4, ties: 2, losses: 1, score: 10.4, image: #imageLiteral(resourceName: "IMG_0305"),
                   history: [exampleMatches[0]]),
            Player(id: 2, firstName: "Islaya", lastName: "Milbank",
                   wins: 0, ties: 6, losses: 1, score: 3.12, image: #imageLiteral(resourceName: "IMG_0329"),
                   history: [exampleMatches[0]]),
            Player(id: 3, firstName: "Mud", lastName: "Mud",
                   wins: 0, ties: 1, losses: 6, score: -1.466, image: #imageLiteral(resourceName: "IMG_1811"),
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
