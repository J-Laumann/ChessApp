//
//  MainViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/19/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var mainPlayers : [Player]! = []
    var playerCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if(UserDefaults.standard.integer(forKey: "players") != 0){
            playerCount = UserDefaults.standard.integer(forKey: "players")
            for i in 0...(playerCount - 1){
                mainPlayers.append(Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi")))
                mainPlayers[i].restore(fileName: "player\(i)")
            }
        }
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
