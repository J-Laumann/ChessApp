//
//  PlayerDetailViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/5/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    
    var player : Player!
    
    @IBOutlet weak var atkLabel: UILabel!
    @IBOutlet weak var spdLabel: UILabel!
    @IBOutlet weak var staLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playerImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = player.title
        atkLabel.text = "ATK: \(player.atk)"
        spdLabel.text = "SPD: \(player.spd)"
        staLabel.text = "STA: \(player.sta)"
        defLabel.text = "DEF: \(player.def)"
        hpLabel.text = "HP: \(player.hp)"
        firstnameLabel.text = String.init(player.title.split(separator: Character.init(" "))[0])
        lastnameLabel.text = String.init(player.title.split(separator: Character.init(" "))[1])
        let newAtk = Double(player.atk) * 1.5
        let newHP = Double(player.hp) * 1.2
        let finalScore = Double(player.def+player.spd+player.sta)+newAtk+newHP
        scoreLabel.text = "\(String(format: "%.00f", finalScore))"
        playerImg.image = player.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
