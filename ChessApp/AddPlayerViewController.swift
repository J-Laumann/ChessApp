//
//  AddPlayerViewController.swift
//  NewspaperExample
//
//  Created by Jackson on 12/17/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import Photos
import GoogleAPIClientForREST
import Google
import GoogleSignIn
import GoogleToolboxForMac
import GTMOAuth2

//By Jackson Laumann
class AddPlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet weak var FirstNameInput: UITextField!
    @IBOutlet weak var LastNameInput:   UITextField!
    @IBOutlet weak var PlayerFirstName: UILabel!
    @IBOutlet weak var PlayerLastName: UILabel!
    @IBOutlet weak var PlayerPicture: UIImageView!
    @IBOutlet var AddPlayerPicture: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var players : [Player] = []
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: "returnSegue", action:    )
        addButton.titleLabel?.numberOfLines = 1
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.titleLabel?.lineBreakMode = .byClipping
        FirstNameInput.returnKeyType = UIReturnKeyType.done
        LastNameInput.returnKeyType = UIReturnKeyType.done
        checkPermission()
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosen = info[UIImagePickerControllerOriginalImage]
        PlayerPicture.image = (chosen as? UIImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized { print("success") }
            })
        case .restricted: print("User do not have access to photo album.")
        case .denied: print("User has denied the permission.")
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
