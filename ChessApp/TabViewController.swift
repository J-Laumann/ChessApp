//
//  TabViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 1/14/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import GoogleAPIClientForREST
import Google
import GTMOAuth2

class TabViewController: UITabBarController {

    var auth : GIDAuthentication!
    var season : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("AUTH: \(auth.clientID)")
        for view in self.viewControllers!{
            if let tableView = view as? StoriesTableViewController {
                tableView.auth = auth
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //YEET
        if(item.tag == 5){
            performSegue(withIdentifier: "backToMain", sender: self)
        }
        else {
            if(self.viewControllers![item.tag - 1].viewIfLoaded != nil){
                self.viewControllers![item.tag - 1].viewDidLoad()
            }
            if let tableView = self.viewControllers![item.tag - 1] as? StoriesTableViewController{
                tableView.auth = auth
            }
            if let newMatchView = self.viewControllers![item.tag - 1] as? NewMatchesView{
                newMatchView.auth = auth
                newMatchView.season = season
            }
            if let tableView = self.viewControllers![item.tag - 1] as? HistoryTableController{
                tableView.tableView.reloadData()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
