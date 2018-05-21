//
//  timeLock.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

/* a timeLock stores a Date variable for the time selected for the lock.
This lock is compared to the receiver's current time on their device.
*/

class timeLock: Lock{
    
    var lockDate = Date()    // store when the lock expires
    let dateFormatter = DateFormatter()
    
    override init(){
        lockDate = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        super.init()
    }
    
    override func checkLock() -> Bool { // is the current time greater than the lock?
        let curD = Date()
        if(curD < lockDate){
            return isLocked
        }
        isLocked = false
        return isLocked
    }
    
    override func getCondition() -> String {
        return "Date locked at  \(dateFormatter.string(from: (lockDate)))"
    }
    
    override func setValues(soFar: String, qRapper: queryItemRapper ) { // set from query items
        var myComponents = DateComponents()
        for queryItem in qRapper.myQueries{
            if queryItem.name == (soFar + "Y") {
                myComponents.year = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "M") {
                myComponents.month = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "D") {
                myComponents.day = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "H") {
                myComponents.hour = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "m") {
                myComponents.minute = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "U"){
                isUsed = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "L"){
                isLocked = Bool(queryItem.value!)!
            }
        }
        lockDate = Calendar.current.date(from: myComponents)!
    }
    
    override func writeValues(soFar: String, qRapper: queryItemRapper){ // write to query items
        let calendar = Calendar.current
        qRapper.myQueries.append(URLQueryItem(name: soFar + "Y", value: String(describing: calendar.component(.year, from:lockDate))))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "M", value: String(describing: calendar.component(.month, from:lockDate))))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "D", value: String(describing: calendar.component(.day, from:lockDate))))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "H", value: String(describing: calendar.component(.hour, from:lockDate))))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "m", value: String(describing: calendar.component(.minute, from:lockDate))))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "L", value: String(describing: isLocked)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "U", value: String(describing: isUsed)))
    }
    
    override func setDefaults(soFar: String){ // write to defaults
        let defaults = UserDefaults.standard
        let calendar = Calendar.current
        defaults.set(String(describing: calendar.component(.year, from:lockDate)), forKey: soFar + "Y")
        defaults.set(String(describing: calendar.component(.month, from:lockDate)), forKey: soFar + "M")
        defaults.set(String(describing: calendar.component(.day, from:lockDate)), forKey: soFar + "D")
        defaults.set(String(describing: calendar.component(.hour, from:lockDate)), forKey: soFar + "H")
        defaults.set(String(describing: calendar.component(.minute, from:lockDate)), forKey: soFar + "m")
        defaults.set(String(describing: isLocked), forKey: soFar + "L")
        defaults.set(String(describing: isUsed), forKey: soFar + "U")
    }
    
    override func getDefaults(soFar: String){ // set current timelock from defaults
        let defaults = UserDefaults.standard
        var myComponents = DateComponents()
        if let str = defaults.string(forKey: soFar + "Y"){
            myComponents.year = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "M"){
            myComponents.month = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "D"){
            myComponents.day = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "H"){
            myComponents.hour = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "m"){
            myComponents.minute = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "U"){
            isUsed = Int(str)!
        }
        if let str = defaults.string(forKey: soFar + "L"){
            isLocked = Bool(str)!
        }
        lockDate = Calendar.current.date(from: myComponents)!
    }
    
    override func clearDefaults(soFar: String){ // clear a time lock's defaults
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: soFar + "Y")
        defaults.removeObject(forKey: soFar + "M")
        defaults.removeObject(forKey: soFar + "D")
        defaults.removeObject(forKey: soFar + "H")
        defaults.removeObject(forKey: soFar + "m")
        defaults.removeObject(forKey: soFar + "U")
        defaults.removeObject(forKey: soFar + "L")
    }
    
}
