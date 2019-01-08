import UIKit

class StoriesTableViewController: UITableViewController {

    var players : [Player]! = [] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do stuff NOW
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddPlayer))
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    @objc func openAddPlayer(){
        performSegue(withIdentifier: "addPlayerSegue", sender: self)
    }
    
    func newPlayer(fn: String, ln: String, image: UIImage){
        players.append(Player(fn: fn, ln: ln, img: image))
        players[players.count - 1].archive(fileName: "player\(players.count - 1)")
        UserDefaults.standard.set(players.count, forKey: "players")
        tableView.reloadData()
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
        cell.textLabel?.text = "\(h.firstName) \(h.lastName)"
        let strBase64: String = h.imgData
        let dataDecoded: Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        cell.imageView?.image = UIImage(data: dataDecoded)
        cell.tag = indexPath.row + 1

        return cell
    }
    
    @IBAction func unwindToTable(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddPlayerViewController {
            newPlayer(fn: sourceViewController.FirstNameInput.text!, ln: sourceViewController.LastNameInput.text!, image: sourceViewController.PlayerPicture.image!)
        }
    }
}
