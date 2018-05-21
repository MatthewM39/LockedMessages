//
//  weatherLock.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation

enum wClimate: String {          // enum for the different types of weather
    case Clear = "Clear"
    case Rainy = "Rainy"
    case Thundering = "Thundering"
    case Cloudy = "Cloudy"
    case Snowing = "Snowing"
}

// A lock that utlizes the wClimate enum to store a weather type.

class weatherLock: Lock{
    
    
    var myWeather: wClimate         // the type of weather required to unlock the message
    
    override init(){
        myWeather = wClimate.Clear
        super.init()
    }
    
    func checkLock(wth: wClimate) -> Bool { // do the weathers match?
        
        if  myWeather.rawValue == wth.rawValue {
            isLocked = false
            return isLocked
        }
        return isLocked
    }
    
    override func getCondition() -> String {
        return "Must be \(myWeather.rawValue)."
    }

    override func setValues(soFar: String, qRapper: queryItemRapper ) { // write to query items
        for queryItem in qRapper.myQueries{
            if queryItem.name == (soFar + "W") {
                myWeather = wClimate(rawValue: queryItem.value!)!
            }
            else if queryItem.name == (soFar + "U"){
                isUsed = Int(queryItem.value!)!
            }
            else if queryItem.name == (soFar + "L"){
                isLocked = Bool(queryItem.value!)!
            }
        }
    }
    
    override func writeValues(soFar: String, qRapper: queryItemRapper){ // read from query items
        qRapper.myQueries.append(URLQueryItem(name: soFar + "W", value: myWeather.rawValue))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "L", value: String(describing: isLocked)))
        qRapper.myQueries.append(URLQueryItem(name: soFar + "U", value: String(describing: isUsed)))
    }
    
    override func setDefaults(soFar: String){ // write to defaults
        let defaults = UserDefaults.standard
        defaults.set(String(describing: myWeather.rawValue), forKey: soFar + "W")
        defaults.set(String(describing: isLocked), forKey: soFar + "L")
        defaults.set(String(describing: isUsed), forKey: soFar + "U")
    }
    
    override func getDefaults(soFar: String){ // read from defaults
        let defaults = UserDefaults.standard
        if let str = defaults.string(forKey: soFar + "W"){
            myWeather = wClimate(rawValue: str)!
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
        defaults.removeObject(forKey: soFar + "W")
        defaults.removeObject(forKey: soFar + "U")
        defaults.removeObject(forKey: soFar + "L")
    }
    
    
}
