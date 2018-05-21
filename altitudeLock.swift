//
//  altitudeLock.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

/* A type of lock based on current geographical altitude. 
 Stores altitude as an integer. Inherits from the Lock class.
 Has an integer tolerance variable to determine how close a user must be to a location.
 */

class altitudeLock: Lock{
    
    var altitude: Int              // store the desired altitude as an integer
    var range: Int                // must be within the range value above or below the altitude

    override init(){
        altitude = 0
        range = 0
        super.init()
    }
    
    init(alt: Int, tolerance: Int){
        altitude = alt
        range = tolerance
        super.init()
    }
    
    func checkLock(alt: Int) -> Bool {    // check if current altitutde is in range and change lock status
        let min = altitude - range
        let max = altitude + range
        if (alt >= min) && (alt <= max){
            isLocked = false
        }
        return isLocked
    }
    
    override func getCondition() -> String {    // override for displaying altitudeLock condition
        return "Must be within  \(range) ft of \(altitude) ft."
    }
    
    override func setValues(soFar: String, qRapper: queryItemRapper ){ // set query items for a message
        
        for queryItem in qRapper.myQueries{
            if queryItem.name == (soFar + "A") {
                altitude = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "R") {
                range = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "L") {
                isLocked = Bool(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "U"){
                isUsed = Int(queryItem.value!)!
            }
        }
    }
    

    
    
    override func writeValues(soFar: String, qRapper: queryItemRapper){ // read query items from an extracted message
        qRapper.myQueries.append(URLQueryItem(name: soFar + "A", value: String(describing: altitude)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "R", value: String(describing: range)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "L", value: String(describing: isLocked)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "U", value: String(describing: isUsed)))
    }
    
    override func setDefaults(soFar: String){ // write the defaults for an altitude to defaults
        let defaults = UserDefaults.standard
        defaults.set(String(describing: altitude), forKey: soFar + "A")
        defaults.set(String(describing: range), forKey: soFar + "R")
        defaults.set(String(describing: isLocked), forKey: soFar + "L")
        defaults.set(String(describing: isUsed), forKey: soFar + "U")
    }
    
    override func getDefaults(soFar: String){ // read the defaults for an altitude and set the current lock to them
        let defaults = UserDefaults.standard
        if let str = defaults.string(forKey: soFar + "A"){
            altitude = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "R"){
            range = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "U"){
            isUsed = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "L"){
            isLocked = Bool(str)!
        }
    }
    override func clearDefaults(soFar: String){ // remove defaults for a given altitude lock
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: soFar + "A")
        defaults.removeObject(forKey: soFar + "R")
        defaults.removeObject(forKey: soFar + "U")
        defaults.removeObject(forKey: soFar + "L")
    }
    
    
}
