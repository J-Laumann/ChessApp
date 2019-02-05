//
//  PlayerDetailViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/5/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GoogleToolboxForMac
import Google
import GTMOAuth2

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
    private let service = GTLRSheetsService()
    var auth : GIDAuthentication!
    
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
        service.authorizer = auth.fetcherAuthorizer()
        let resource = GTLRSheets_ValueRange.init()
        resource.values = [["","","","","","","",""]]
        if index != (player.history.count - 1){
            resource.values = []
            for i in index+1...player.history.count - 1{
                var resultText = "?"
                var pointsText = "0"
                if player.history[i].result == 0 {
                    resultText = "W"
                    if(player.history[i].boardNumb < 6){
                        pointsText = "\(21 - player.history[i].boardNumb)"
                    }
                    else if(player.history[i].boardNumb == 6){
                        pointsText = "10"
                    }
                    else{
                        pointsText = "0"
                    }
                }
                else if player.history[i].result == 1 {
                    resultText = "L"
                }
                else{
                    resultText = "T"
                    if(player.history[i].boardNumb < 6){
                        pointsText = "\(Int(10.5 - (Double(player.history[i].boardNumb) * 0.5)))"
                    }
                    else if(player.history[i].boardNumb == 6){
                        pointsText = "5"
                    }
                    else{
                        pointsText = "0"
                    }
                }
                resource.values?.append([
                    "\(i + 1)",
                    "\(player.history[i].month)/\(player.history[i].day)/\(player.history[i].year)",
                    "\(player.history[i].boardNumb)",
                    "W",
                    "\(player.history[i].opponent)",
                    "\(player.history[i].opponentSchool)",
                    "\(resultText)",
                    "\(pointsText)"
                    ])
            }
            resource.values?.append(["","","","","","","",""])
        }
        let spreadsheetId = player.sheetID
        let range = "A\(16+index):H\(16+player.history.count-1)"
        print("\(range) : \(String(describing: resource.values))")
        resource.range = range
        let editQuery = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: resource, spreadsheetId: spreadsheetId, range: range)
        editQuery.valueInputOption = "RAW"
        editQuery.insertDataOption = "OVERWRITE"
        editQuery.completionBlock = { (ticket, result, NSError) in
            var matches : [HistoryMatch] = []
            for i in 0...(UserDefaults.standard.integer(forKey: "\(self.season)matches")){
                matches.append(HistoryMatch.init(player: Player.init(fn: "", ln: "", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID: ""), oppName: "", oppSchool: "", board: 1, result: 1, m: 1, d: 1, y: 1))
                matches[i].restore(fileName: "\(self.season)match\(i)")
            }
            print("To Remove from History... \(self.player.history[index].id)")
            matches.remove(at: self.player.history[index].id)
            UserDefaults.standard.set(matches.count, forKey: "\(self.season)matches")
            if(matches.count > 0){
                for i in 0...(matches.count - 1){
                    matches[i].archive(fileName: "\(self.season)match\(i)")
                }
            }
            self.player.history.remove(at: (index))
            self.player.archive(fileName: "\(self.season)player\(Int(self.slot))")
            self.tableView.reloadData()
        }
        service.executeQuery(editQuery, completionHandler: nil)
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
