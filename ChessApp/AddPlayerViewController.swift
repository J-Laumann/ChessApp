//
//  AddPlayerViewController.swift
//  NewspaperExample
//
//  Created by Isaiah on 12/17/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: "returnSegue", action:    )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnSegue" {
            let detailView = segue.destination as? StoriesTableViewController
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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