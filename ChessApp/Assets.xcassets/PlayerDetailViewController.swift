//
//  PlayerDetailViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/5/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class HistoryTableViewCell : UITableViewCell{
    
    @IBOutlet weak var oppName: UILabel!
    @IBOutlet weak var oppSchool: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var boardText: UILabel!
    
}

class PlayerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var player : Player!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playerImg: UIImageView!
    @IBOutlet weak var winlosstieText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "\(player.firstName) \(player.lastName)"
        nameLabel.text = "\(player.firstName) \(player.lastName)"
        scoreLabel.text = "\(player.score)"
        playerImg.image = player.image
        winlosstieText.text = "\(player.wins) - \(player.losses) - \(player.ties)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        cell.selectionStyle = .none
        let match : Match = player.history[indexPath.row]
        cell.oppName.text = match.opponent
        cell.oppSchool.text = match.opponentSchool
        cell.boardText.text = "\(match.boardNumb)"
        if(match.result == 0){ cell.result.text = "W" }
        else if(match.result == 1){ cell.result.text = "L" }
        else if(match.result == 2){ cell.result.text = "T" }
        cell.dateText?.text = "12 / 31 / 2018"
        
        return cell
    }
    
}
