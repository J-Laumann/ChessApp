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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if(UserDefaults.standard.integer(forKey: "players") != 0){
            playerCount = UserDefaults.standard.integer(forKey: "players")
            for i in 0...(playerCount - 1){
                mainPlayers.append(Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "IMG_0305")))
                mainPlayers[i].restore(fileName: "player\(i)")
            }
        }
        
        for _ in 0...10{
            randomMatch()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randomMatch(){
        if(playerCount > 0){
            mainPlayers[Int(arc4random_uniform(UInt32(mainPlayers.count - 1)))].history.append(Match(oppName: "Someone", oppSchool: "Somewhere", board: Int(1 + arc4random_uniform(9)), result: Int(arc4random_uniform(2)), m: Int(1 + arc4random_uniform(11)), d: Int(1 + arc4random_uniform(27)), y: (2018 + Int(arc4random_uniform(1)))))
        }
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
