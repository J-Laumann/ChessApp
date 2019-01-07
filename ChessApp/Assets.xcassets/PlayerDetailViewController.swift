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
    
    var wins : Int = 0
    var losses : Int = 0
    var ties : Int = 0
    var score : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "\(player.firstName) \(player.lastName)"
        nameLabel.text = "\(player.firstName) \(player.lastName)"
        playerImg.image = player.image
        
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
        if(match.result == 0){ cell.result.text = "W"; wins += 1
            if(match.boardNumb >= 5){
                score += Double(21 - match.boardNumb)
            }
            else{
                score += 10.0
            }
        }
        else if(match.result == 1){ cell.result.text = "L"; losses += 1
            //no added score
        }
        else if(match.result == 2){ cell.result.text = "T"; ties += 1
            if(match.boardNumb >= 5){
                score += Double(10.5 - (Double(match.boardNumb) * 0.5))
            }
            else{
                score += 5
            }
        }
        winlosstieText.text = "\(wins) - \(losses) - \(ties)"
        scoreLabel.text = "\(score)"
        cell.dateText?.text = "12 / 31 / 2018"
        
        return cell
    }
    
}
