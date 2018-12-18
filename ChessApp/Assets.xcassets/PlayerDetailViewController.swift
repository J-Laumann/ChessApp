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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playerImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "\(player.firstName) \(player.lastName)"
        nameLabel.text = "\(player.firstName) \(player.lastName)"
        scoreLabel.text = "\(player.score)"
        playerImg.image = player.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
