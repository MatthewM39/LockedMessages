//
//  lockedMessageObject.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation
import Messages

/* The lockedMessageObject contains a lock status, a messsage, an author,
 a copy of the message, and the two sets of locks that can open the message.
 This object is use to maintain changes to a message that is created and to
 unlock conditions.
 */


class lockedMessageObject{
    
    var isLocked: Bool                                        // the current message is locked
    var myMessage: String                                    // the text of the message
    var rowA: lockedMessageRow                             // the first conditional set of locks
    var rowB: lockedMessageRow                            // the second set of conditional locks

    init(){
        isLocked = false
        myMessage = " "
        rowA = lockedMessageRow()
        rowB = lockedMessageRow()
    }

    // return true for a message that is open and set the message lock status
    func checkLockStatus() -> Bool{
        if !(rowA.isUsed) && !(rowB.isUsed){
            isLocked = false
            return false
        }
        if rowA.isUsed{
            if rowA.checkRow(){
                isLocked = false
                return true
            }
        }
        if rowB.isUsed{
            if rowB.checkRow(){
                isLocked = false
                return true
            }
        }
        isLocked = true
        return false
    }
    
    // for a message that only has one set of locks, shift it to the first row
    func shiftRows(){
        if (rowA.isUsed == false){
            if(rowB.isUsed){
                rowA.isUsed = true
                rowB.isUsed = false
                rowA.altitude = rowB.altitude
                rowB.altitude.isUsed = 0
                rowA.location = rowB.location
                rowB.location.isUsed = 0
                rowA.pin = rowB.pin
                rowB.pin.isUsed = 0
                rowA.temp = rowB.temp
                rowB.temp.isUsed = 0
                rowA.time = rowB.time
                rowB.time.isUsed = 0
                rowA.weather = rowB.weather
                rowB.weather.isUsed = 0
            }
        }
    }
    
    
    func setValues(ind: String, qRapper: queryItemRapper){   // set from query items
        rowA.setValues(soFar: (ind + "A"), qRapper: qRapper)
        rowB.setValues(soFar: (ind + "B"), qRapper: qRapper)
        for queryItem in qRapper.myQueries{
            if queryItem.name == (ind + "m") {
                myMessage = queryItem.value!
            }
            else if queryItem.name == (ind + "L") {
                isLocked = Bool(queryItem.value!)!
            }
        }

    }
    
    func writeValues(ind: String, qRapper: queryItemRapper) { // write to query items
        rowA.writeValues(soFar: ind + "A", qRapper: qRapper)
        rowB.writeValues(soFar: ind + "B", qRapper: qRapper)
        qRapper.myQueries.append(URLQueryItem(name: (ind + "m"), value: myMessage))
        qRapper.myQueries.append(URLQueryItem(name: (ind + "L"), value: String(describing: isLocked)))
    }
    
    func setDefaults(ind: String){ // write to defaults
        let defaults = UserDefaults.standard
        rowA.setDefaults(soFar: ind + "A")
        rowB.setDefaults(soFar: ind + "B")
        defaults.set((myMessage), forKey: ind + "m")
        defaults.set(String(describing: isLocked), forKey: ind + "L")
    }
    
    func getDefaults(ind: String){ // get from defaults
        let defaults = UserDefaults.standard
        rowA.getDefaults(soFar: ind + "A")
        rowB.getDefaults(soFar: ind + "B")
        if let str = defaults.string(forKey: ind + "m"){
            myMessage = str
        }
        if let str = defaults.string(forKey: ind + "L"){
            isLocked = Bool(str)!
        }
    }

    func clearDefaults(ind: String){ // clear defaults for a lock
        let defaults = UserDefaults.standard
        rowA.clearDefaults(soFar: ind + "A")
        rowB.clearDefaults(soFar: ind + "B")
        defaults.removeObject(forKey: ind + "m")
        defaults.removeObject(forKey: ind + "L")
    }
    
}
