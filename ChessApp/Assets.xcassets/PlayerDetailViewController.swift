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
    @IBOutlet weak var removeButton: UIButton!
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
    var slot : Int!
    var season : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        season = UserDefaults.standard.integer(forKey: "season")
        self.navigationController?.isToolbarHidden = false
        tableView.allowsMultipleSelectionDuringEditing = false
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "\(player.firstName) \(player.lastName)"
        nameLabel.text = "\(player.firstName) \(player.lastName)"
        let strBase64: String = player.imgData
        let dataDecoded: Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        playerImg.image = UIImage(data: dataDecoded)
        winlosstieText.text = "\(wins) - \(losses) - \(ties)"
        scoreLabel.text = "\(score)"
        for match in player.history{
            if(match.result == 0){ wins += 1
                if(match.boardNumb <= 5){
                    score += Double(21 - match.boardNumb)
                }
                else if(match.boardNumb == 6){
                    score += 10.0
                }
            }
            else if(match.result == 1){ losses += 1
                //no added score
            }
            else if(match.result == 2){ ties += 1
                if(match.boardNumb <= 5){
                    score += Double(10.5 - (Double(match.boardNumb) * 0.5))
                }
                else if(match.boardNumb == 6){
                    score += 5
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeMatch(index: Int) {
        player.history.remove(at: (index))
        player.archive(fileName: "\(season)player\(Int(slot))")
        var matches : [HistoryMatch] = []
        for i in 0...(UserDefaults.standard.integer(forKey: "\(season)matches") - 1){
            matches.append(HistoryMatch.init(player: Player.init(fn: "", ln: "", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: 1, result: 1, m: 1, d: 1, y: 1))
            matches[i].restore(fileName: "\(season)match\(i)")
        }
        matches.remove(at: index)
        UserDefaults.standard.set(matches.count, forKey: "\(season)matches")
        if(matches.count > 0){
            for i in 0...(matches.count - 1){
                matches[i].archive(fileName: "\(season)match\(i)")
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.history.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            removeMatch(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        cell.selectionStyle = .none
        let match : Match = player.history[indexPath.row]
        cell.oppName.text = match.opponent
        cell.oppSchool.text = match.opponentSchool
        cell.boardText.text = "\(match.boardNumb)"
        winlosstieText.text = "\(wins) - \(losses) - \(ties)"
        scoreLabel.text = "\(score)"
        cell.dateText?.text = "\(match.month)/\(match.day)/\(match.year)"
        if(match.result == 0){ cell.result.text = "W"; cell.result.textColor = UIColor.green}
        else if(match.result == 1){ cell.result.text = "L"; cell.result.textColor = .red}
        else if(match.result == 2){ cell.result.text = "T"; cell.result.textColor = .black}
        cell.tag = indexPath.row
        return cell
    }
}
