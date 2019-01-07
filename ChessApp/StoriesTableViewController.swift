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
    
    func newPlayer(fn: String, ln: String){
        players.append(Player(id: players.count + 1, firstName: fn, lastName: ln, image: #imageLiteral(resourceName: "IMG_0305"), history: []))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playerSegue" {
            let detailView = segue.destination as? PlayerDetailViewController
            let cell = sender as! UITableViewCell
            if let dvc = detailView {
                dvc.player =  players[cell.tag - 1]
            }
        }
        if(segue.identifier == "addPlayerSegue"){
            let dv = segue.destination as? AddPlayerViewController
            dv?.players = players
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        let h = players[indexPath.row]
        cell.textLabel?.text = "\(h.firstName) \(h.lastName)"
        cell.imageView?.image = h.image
        cell.tag = h.id

        return cell
    }

}
