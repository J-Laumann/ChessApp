//
//  AddPlayerViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/17/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet weak var FirstNameInput: UITextField!
    @IBOutlet weak var LastNameInput:   UITextField!
    @IBOutlet weak var PlayerFirstName: UILabel!
    @IBOutlet weak var PlayerLastName: UILabel!
    @IBOutlet weak var PlayerPicture: UIImageView!
    @IBOutlet var AddPlayerPicture: UIView!
    
    var players : [Player] = []
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: "returnSegue", action:    )
        FirstNameInput.returnKeyType = UIReturnKeyType.done
        LastNameInput.returnKeyType = UIReturnKeyType.done
        
    }

    @IBAction func doneFN(_ sender: UITextField) {
        FirstNameInput.resignFirstResponder()
    }
    
    @IBAction func donLN(_ sender: UITextField) {
        LastNameInput.resignFirstResponder()
    }

    @IBAction func changeImage(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        PlayerPicture.image = image
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
