//
//  pinLock.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

/* a pinLock has four variables. each is an integer which corresponds to a slot in the lock
 and the value required for the slot.
 */

class pinLock: Lock{
    
    var first: Int                 // each variable corresponds to a value in the lock
    var second: Int               
    var third: Int
    var fourth: Int
    
    override init(){
        first = 0
        second = 0
        third = 0
        fourth = 0
        super.init()
    }
    
    // compare a user input to the correct lock values
    func checkLock(one: Int, two: Int, three: Int, four: Int) -> Bool {
        
        if (first == one) && (second == two) && (third == three) && (fourth == four){
            isLocked = false
        }
        return isLocked
    }
    
    override func getCondition() -> String {
        return "You must enter the correct PIN."
    }
    
    override func setValues(soFar: String, qRapper: queryItemRapper ) { // set from query items
        for queryItem in qRapper.myQueries{
            if queryItem.name == (soFar + "1") {
                first = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "2") {
                second = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "3") {
                third = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "4"){
                fourth = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "U"){
                isUsed = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "L"){
                isLocked = Bool(queryItem.value!)!
            }
        }
    }
    
    override func writeValues(soFar: String, qRapper: queryItemRapper){ // write to query items
        qRapper.myQueries.append(URLQueryItem(name: soFar + "1", value: String(describing: first)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "2", value: String(describing: second)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "3", value: String(describing: third)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "4", value: String(describing: fourth)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "L", value: String(describing: isLocked)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "U", value: String(describing: isUsed)))
    }
 
    override func setDefaults(soFar: String){ // set defaults
        let defaults = UserDefaults.standard
        defaults.set(String(describing: first), forKey: soFar + "1")
        defaults.set(String(describing: second), forKey: soFar + "2")
        defaults.set(String(describing: third), forKey: soFar + "3")
        defaults.set(String(describing: fourth), forKey: soFar + "4")
        defaults.set(String(describing: isUsed), forKey: soFar + "U")
        defaults.set(String(describing: isLocked), forKey: soFar + "L")
    }
    
    override func getDefaults(soFar: String){ // get values from defaults
        let defaults = UserDefaults.standard
        if let str = defaults.string(forKey: soFar + "1"){
            first = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "2"){
            second = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "3"){
            third = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "4"){
            fourth = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "U"){
            isUsed = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "L"){
            isLocked = Bool(str)!
        }
    }

    override func clearDefaults(soFar: String){ // clear defaults for a pin
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: soFar + "1")
        defaults.removeObject(forKey: soFar + "2")
        defaults.removeObject(forKey: soFar + "3")
        defaults.removeObject(forKey: soFar + "4")
        defaults.removeObject(forKey: soFar + "U")
        defaults.removeObject(forKey: soFar + "L")
    }
    
    
    
    
}
