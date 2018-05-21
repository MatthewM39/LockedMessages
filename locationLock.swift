//
//  locationLock.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

/* A locationLock contains a few simple variables. Like all other locks, it has
 a variable which states whether it is unlocked or locked. It also contains
 variables to store the latitude and longitude of a location. The radius gives
 a circumference for a user to be within to a location. 
*/

class locationLock: Lock{
    
    var radius: Int              // range for the gps precision
    var long: Double            // longitude
    var lat: Double            // latitude
    
    override init(){
        radius = 0
        long = 0
        lat = 0
        super.init()
    }
    
    func checkLock(dist: Int) -> Bool { // see if the distance is within the threshold
        if dist < radius {
            isLocked = false
        }
        return isLocked
    }
    
    override func getCondition() -> String { // return the radius and coordinate the user must be within
        return "Will unlock within \(radius) feet of Long: \(long) Lat: \(lat)."
    }

    override func setValues(soFar: String, qRapper: queryItemRapper) { // get query values
        for queryItem in qRapper.myQueries{
            if queryItem.name == (soFar + "O") {
                long = Double(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "A") {
                lat = Double(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "R") {
                radius = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "L"){
                isLocked = Bool(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "U"){
                isUsed = Int(queryItem.value!)!
            }
        }
    }
    
    override func writeValues(soFar: String, qRapper: queryItemRapper){ // write query values
        qRapper.myQueries.append(URLQueryItem(name: soFar + "O", value: String(describing: long)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "A", value: String(describing: lat)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "R", value: String(describing: radius)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "L", value: String(describing: isLocked)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "U", value: String(describing: isUsed)))
    }
    
    override func setDefaults(soFar: String){ // write to defaults
        let defaults = UserDefaults.standard
        defaults.set(String(describing: long), forKey: soFar + "O")
        defaults.set(String(describing: lat), forKey: soFar + "A")
        defaults.set(String(describing: radius), forKey: soFar + "R")
        defaults.set(String(describing: isUsed), forKey: soFar + "U")
        defaults.set(String(describing: isLocked), forKey: soFar + "L")
    }
    
    override func getDefaults(soFar: String){ // read from defaults
        let defaults = UserDefaults.standard
        if let str = defaults.string(forKey: soFar + "O"){
            long = Double(str)!
        }
        if let str = defaults.string(forKey: soFar + "A"){
            lat = Double(str)!
        }
        if let str = defaults.string(forKey: soFar + "R"){
            radius = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "U"){
            isUsed = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "L"){
            isLocked = Bool(str)!
        }
    }

    override func clearDefaults(soFar: String){ // clear the defaults
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: soFar + "O")
        defaults.removeObject(forKey: soFar + "A")
        defaults.removeObject(forKey: soFar + "R")
        defaults.removeObject(forKey: soFar + "U")
        defaults.removeObject(forKey: soFar + "L")
    }
    
    
    
}
