//
//  lockedMessageRow.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

/*
 A lockedMessageRow is an object that contains a variable of each type of lock.
 It merely serves as a collection of each type of lock. Two lockedMessageRows
 are contained inside of each locked message.
 */

class lockedMessageRow{
    
    
    var location: locationLock      // lock variables
    var time: timeLock
    var pin: pinLock
    var weather: weatherLock
    var temp: tempLock
    var altitude: altitudeLock
    var isUsed: Bool                // is the row used?
    
    init(){
        location = locationLock()
        time = timeLock()
        pin = pinLock()
        weather = weatherLock()
        temp = tempLock()
        altitude = altitudeLock()
        isUsed = false              // a row defaults to not being used
    }
    
    func checkUsed(){               // sets isUsed to true is one of the locks is used
        if ((location.isUsed > 0) || (time.isUsed > 0 ) || (pin.isUsed > 0) || (weather.isUsed > 0) || (temp.isUsed > 0) || (altitude.isUsed > 0)){
            isUsed = true
        }
        else {
            isUsed = false
        }
    }
    
    func checkRow() -> Bool{ // function to check if a row is unlocked
        if (location.checkStatus() && time.checkStatus() && pin.checkStatus() && weather.checkStatus() && temp.checkStatus() && altitude.checkStatus()){
            return true
        }
        return false
    }
    
    func setValues(soFar: String, qRapper: queryItemRapper ) {          // set from query items
        location.setValues(soFar: soFar + "L", qRapper: qRapper)
        altitude.setValues(soFar: soFar + "A", qRapper: qRapper)
        pin.setValues(soFar: soFar + "P", qRapper: qRapper)
        temp.setValues(soFar: soFar + "T", qRapper: qRapper)
        weather.setValues(soFar: soFar + "W", qRapper: qRapper)
        time.setValues(soFar: soFar + "t", qRapper: qRapper)
        for queryItem in qRapper.myQueries{
            if queryItem.name == (soFar) {
                isUsed = Bool(queryItem.value!)!
            }
        }
    }
    
    func writeValues(soFar: String, qRapper: queryItemRapper){      // write to query items
        location.writeValues(soFar: soFar + "L", qRapper: qRapper)
        altitude.writeValues(soFar: soFar + "A", qRapper: qRapper)
        pin.writeValues(soFar: soFar + "P", qRapper: qRapper)
        temp.writeValues(soFar: soFar + "T", qRapper: qRapper)
        weather.writeValues(soFar: soFar + "W", qRapper: qRapper)
        time.writeValues(soFar: soFar + "t", qRapper: qRapper)
        qRapper.myQueries.append(URLQueryItem(name: soFar, value: String(describing: isUsed)))
    }

    func setDefaults(soFar: String){            // set defaults
        let defaults = UserDefaults.standard
        location.setDefaults(soFar: soFar + "L")
        altitude.setDefaults(soFar: soFar + "A")
        pin.setDefaults(soFar: soFar + "P")
        temp.setDefaults(soFar: soFar + "T")
        weather.setDefaults(soFar: soFar + "W")
        time.setDefaults(soFar: soFar + "t")
        defaults.set(String(describing: isUsed), forKey: soFar)
    }
    
    func getDefaults(soFar: String){        // get from defaults
        let defaults = UserDefaults.standard
        location.getDefaults(soFar: soFar + "L")
        altitude.getDefaults(soFar: soFar + "A")
        pin.getDefaults(soFar: soFar + "P")
        temp.getDefaults(soFar: soFar + "T")
        weather.getDefaults(soFar: soFar + "W")
        time.getDefaults(soFar: soFar + "t")
        if let str = defaults.string(forKey: soFar){
            isUsed = Bool(str)!
        }
    }
    
    func clearDefaults(soFar: String){      // clear defaults for a row
        let defaults = UserDefaults.standard
        location.clearDefaults(soFar: soFar + "L")
        altitude.clearDefaults(soFar: soFar + "A")
        pin.clearDefaults(soFar: soFar + "P")
        temp.clearDefaults(soFar: soFar + "T")
        weather.clearDefaults(soFar: soFar + "W")
        time.clearDefaults(soFar: soFar + "t")
        defaults.removeObject(forKey: soFar)
    }
    
}
