//
//  lock.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/2/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

/* The standard Lock class. Is the parent of all other types of locks.
 Contains an isUsed and an isLocked variable. 
 */

class Lock{
    
    var isLocked: Bool        // the current message is locked
    var isUsed: Int         // this lock is used
    
    init(){
        isLocked = false
        isUsed = 0
    }
    
    func checkLock() -> Bool {
        return true
    }
    
    func getCondition() -> String {
        return " "
    }
    
    
    // returns true for a lock that isn't used or isn't locked
    func checkStatus() -> Bool{
        if isUsed > 0 {
            if (isLocked){
                return false
            }
        }
        return true
    }
    
    func setValues(soFar: String, qRapper: queryItemRapper ) { // set a current lock's values from query items
    }
    
    func writeValues(soFar: String, qRapper: queryItemRapper){ // write current lock values to query items
        
    }
    
    func getDefaults(soFar: String){ // load values from defaults
    
    }
    
    func setDefaults(soFar: String){ // write values to defaults
        
    }
    
    func clearDefaults(soFar: String){ // clear defaults
    
    }
    
}
