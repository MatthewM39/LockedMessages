//
//  tempLock.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

/* A tempLock is a temperature based lock that uses an integer to store the temperature
 and another to store the range of degrees to be within
 */

class tempLock: Lock{
    

    var temp: Int                  // store the temperature as an integer
    var range: Int                // must be within the range value above or below the temperature

    override init(){
        temp = 70
        range = 0
        super.init()
    }
    
    func checkLock(tmp: Int) -> Bool { // see if current temp is within the range
        
        let min = temp - range
        let max = temp + range
        if (tmp >= min) && (tmp <= max){
            isLocked = false
            return isLocked
        }
        return isLocked
    }
    
    override func getCondition() -> String {
        return "Must be within  \(range) ° of \(temp) °."
    }

    override func setValues(soFar: String, qRapper: queryItemRapper ) { // set from query items
        for queryItem in qRapper.myQueries{
            if queryItem.name == (soFar + "T") {
                temp = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "R") {
                range = Int(queryItem.value!)!
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
        qRapper.myQueries.append(URLQueryItem(name: soFar + "T", value: String(describing: temp)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "R", value: String(describing: range)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "U", value: String(describing: isUsed)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "L", value: String(describing: isLocked)))
    }

    override func setDefaults(soFar: String){ // write to defaults
        let defaults = UserDefaults.standard
        defaults.set(String(describing: temp), forKey: soFar + "T")
        defaults.set(String(describing: range), forKey: soFar + "R")
        defaults.set(String(describing: isLocked), forKey: soFar + "L")
        defaults.set(String(describing: isUsed), forKey: soFar + "U")
    }
    
    override func getDefaults(soFar: String){ // set from defaults
        let defaults = UserDefaults.standard
        if let str = defaults.string(forKey: soFar + "T"){
            temp = Int(str)!
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
    
    override func clearDefaults(soFar: String){ // clear defaults
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: soFar + "T")
        defaults.removeObject(forKey: soFar + "R")
        defaults.removeObject(forKey: soFar + "U")
        defaults.removeObject(forKey: soFar + "L")
    }
    
}
