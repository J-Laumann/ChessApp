//
//  PlayerClass.swift
//  NewspaperExample
//
//  Created by Isaiah on 12/17/18.
//  Copyright © 2018 Example. All rights reserved.
//
// ********** Replace all the 7 occurances of "PlayerClass" in this file *************
// ********** with the name of your class. 5 occurannces are comments. *************
//  PlayerClass.swift
//  Class definition which creates a "Codable" data structure which can be
//  archived (or saved) and be restored later - even after a restart of the application.
//
//  Created by George Behnke on 1/14/18.
//  Copyright © 2018 George Behnke. All rights reserved.
//

import Foundation
import os.log
import UIKit

// **** Replace "PlayerClass" with the name of your class object to be persistent ***
class Player: Codable {
    // **** These are all the Properties of the object to be persistent. ****
    // **** Every Property must be "Codable".                            ****
    var firstName: String
    var lastName: String
    var imgData: String
    var sheetID: String
    var history : [Match]
    var index : Int

    
    // **** The initializer ("constructor" in Java terms) gives the persistent object its initial values ****
    // **** before it is restored from an archived value. Every Property must have an initial value. ****
    init(fn: String, ln: String, img: UIImage, shtID: String) {
        firstName = fn
        lastName = ln
        let imageData: Data = UIImagePNGRepresentation(img)!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        imgData = strBase64
        sheetID = shtID
        history = []
        let season = UserDefaults.standard.integer(forKey: "season")
        index = UserDefaults.standard.integer(forKey:"\(season)players")
    }
    
    // ********** You should not have to change ANYTHING in "func archive()" to use *************
    /**
     * Archive this PlayerClass object
     * @param: fileName from which to archived this object
     */
    func archive(fileName: String) {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            let encodedData = try PropertyListEncoder().encode(self)
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(encodedData, toFile: archiveURL.path)
            if isSuccessfulSave {
                //os_log("Data successfully saved to file.", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to save data...", log: OSLog.default, type: .error)
            }
        } catch {
            os_log("Failed to save data...", log: OSLog.default, type: .error)
        }
    }
    
    // ********** Replace "PlayerClass" in this function with your class's name *************
    // ********** Restore the recovered values into object's current values *************
    /**
     * Recover the previously archived PlayerClass object
     * @param: fileName from which to recover the previously archived file
     */
    func restore(fileName: String) {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(fileName)
        if let recoveredDataCoded = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? Data {
            do {
                // *** Replace "PlayerClass" on the next line with the name of the class to be persistent. ***
                let recoveredData = try PropertyListDecoder().decode(Player.self, from: recoveredDataCoded)
                //os_log("Data successfully recovered from file.", log: OSLog.default, type: .debug)
                // *** Replace all the assignment statements BELOW to "restore" all properties of the object ***
                firstName = recoveredData.firstName
                lastName = recoveredData.lastName
                imgData = recoveredData.imgData
                history = recoveredData.history
                sheetID = recoveredData.sheetID
                index = recoveredData.index
                // *** Replace all the assignment statements ABOVE to "restore" all properties of the object ***
            } catch {
                os_log("Failed to recover data", log: OSLog.default, type: .error)
            }
        } else {
            os_log("Failed to recover data", log: OSLog.default, type: .error)
        }
    }
    
}
