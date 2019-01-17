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
class Match: Codable {
    // **** These are all the Properties of the object to be persistent. ****
    // **** Every Property must be "Codable".                            ****
    var opponent : String
    var opponentSchool : String
    var boardNumb : Int
    //result - 0 = win, 1 = loss, 2 = tie
    var result : Int
    var month : Int
    var day: Int
    var year: Int
    var id : Int
    
    
    // **** The initializer ("constructor" in Java terms) gives the persistent object its initial values ****
    // **** before it is restored from an archived value. Every Property must have an initial value. ****
    init(oppName: String, oppSchool: String, board: Int, result: Int, m: Int, d: Int, y: Int, id: Int){
        self.opponent = oppName
        self.opponentSchool = oppSchool
        self.boardNumb = board
        self.result = result
        self.month = m
        self.day = d
        self.year = y
        self.id = id
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
                let recoveredData = try PropertyListDecoder().decode(Match.self, from: recoveredDataCoded)
                //os_log("Data successfully recovered from file.", log: OSLog.default, type: .debug)
                // *** Replace all the assignment statements BELOW to "restore" all properties of the object ***
                opponentSchool = recoveredData.opponentSchool
                opponent = recoveredData.opponent
                boardNumb = recoveredData.boardNumb
                result = recoveredData.result
                month = recoveredData.month
                day = recoveredData.day
                year = recoveredData.year
                id = recoveredData.id
                // *** Replace all the assignment statements ABOVE to "restore" all properties of the object ***
            } catch {
                os_log("Failed to recover data", log: OSLog.default, type: .error)
            }
        } else {
            os_log("Failed to recover data", log: OSLog.default, type: .error)
        }
    }
    
}

class HistoryMatch : Codable {
    // **** These are all the Properties of the object to be persistent. ****
    // **** Every Property must be "Codable".                            ****
    var opponent : String
    var opponentSchool : String
    var boardNumb : Int
    //result - 0 = win, 1 = loss, 2 = tie
    var result : Int
    var month : Int
    var day: Int
    var year: Int
    var player : Player
    
    
    // **** The initializer ("constructor" in Java terms) gives the persistent object its initial values ****
    // **** before it is restored from an archived value. Every Property must have an initial value. ****
    init(player: Player,oppName: String, oppSchool: String, board: Int, result: Int, m: Int, d: Int, y: Int){
        self.opponent = oppName
        self.opponentSchool = oppSchool
        self.boardNumb = board
        self.result = result
        self.month = m
        self.day = d
        self.year = y
        self.player = player
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
                let recoveredData = try PropertyListDecoder().decode(HistoryMatch.self, from: recoveredDataCoded)
                //os_log("Data successfully recovered from file.", log: OSLog.default, type: .debug)
                // *** Replace all the assignment statements BELOW to "restore" all properties of the object ***
                player = recoveredData.player
                opponentSchool = recoveredData.opponentSchool
                opponent = recoveredData.opponent
                boardNumb = recoveredData.boardNumb
                result = recoveredData.result
                month = recoveredData.month
                day = recoveredData.day
                year = recoveredData.year
                // *** Replace all the assignment statements ABOVE to "restore" all properties of the object ***
            } catch {
                os_log("Failed to recover data", log: OSLog.default, type: .error)
            }
        } else {
            os_log("Failed to recover data", log: OSLog.default, type: .error)
        }
    }
    
}

