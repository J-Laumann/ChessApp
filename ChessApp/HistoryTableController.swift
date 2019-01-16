//
//  HistoryTableController.swift
//  NewspaperExample
//
//  Created by Jackson on 1/10/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class HistoryCell : UITableViewCell {
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var opponentInfo: UILabel!
    @IBOutlet weak var Board: UILabel!
    @IBOutlet weak var result: UILabel!
}

class HistoryTableController: UITableViewController {

    var season : Int!
    var matches : [HistoryMatch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        season = UserDefaults.standard.integer(forKey: "season")
        if(UserDefaults.standard.integer(forKey: "\(season)matches") > 0){
            for i in 0...(UserDefaults.standard.integer(forKey: "\(season)matches")){
                matches.append(HistoryMatch.init(player: Player.init(fn: "Place", ln: "Holder", img: #imageLiteral(resourceName: "avatar-male-silhouette-hi"), shtID:""), oppName: "Place", oppSchool: "Holder", board: 1, result: 1, m: 1, d: 1, y: 1))
                matches[i].restore(fileName: "\(season)match\(i)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserDefaults.standard.integer(forKey: "\(season)matches")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchHistoryCell", for: indexPath) as! HistoryCell
        let i = ((UserDefaults.standard.integer(forKey: "\(season)matches") - 1) - indexPath.row)
        cell.date.text = "\(matches[i].month) / \(matches[i].day) / \(matches[i].year)"
        cell.Board.text = "\(matches[i].boardNumb)"
        cell.opponentInfo.text = "\(matches[i].opponent) : \(matches[i].opponentSchool)"
        cell.playerName.text = "\(matches[i].player.firstName) \(matches[i].player.lastName)"
        if(matches[i].result == 0){
            cell.result.text = "Win"
            cell.result.textColor = UIColor.green
        }
        else if(matches[i].result == 1){
            cell.result.text = "Loss"
            cell.result.textColor = UIColor.red
        }
        else{
            cell.result.text = "Tie"
            cell.result.textColor = UIColor.black
        }
        cell.selectionStyle = .none
        return cell
    }
    
    /*
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        //context.nextFocusedView
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
