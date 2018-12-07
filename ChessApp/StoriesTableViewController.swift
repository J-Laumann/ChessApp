import UIKit

struct Player {

    var id : Int
    var title : String
    var wins: Int
    var ties: Int
    var losses: Int
    var score: Double
    var image : UIImage

}

class StoriesTableViewController: UITableViewController {

    var players = [
        Player(id: 1, title: "Jackson Laumann",
               wins: 4, ties: 2, losses: 1, score: 5138008, image: #imageLiteral(resourceName: "IMG_0305")),
        Player(id: 2, title: "Islaya Milbank",
               wins: 0, ties: 6, losses: 1, score: 3.12, image: #imageLiteral(resourceName: "IMG_0329")),
        Player(id: 3, title: "Mud Mud",
               wins: 0, ties: 1, losses: 6, score: -1.466, image: #imageLiteral(resourceName: "IMG_1811"))
        ]

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playerSegue" {
            let detailView = segue.destination as? PlayerDetailViewController
            let cell = sender as! UITableViewCell
            if let dvc = detailView {
                dvc.player =  players[cell.tag - 1]
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        let h = players[indexPath.row]
        cell.textLabel?.text = "\(h.title)"
        cell.detailTextLabel?.text = "SCORE: \(h.score))"
        cell.imageView?.image = h.image
        cell.tag = h.id

        return cell
    }

}
