//
//  lockedMessageContainer.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/15/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import Foundation
import Messages

/*
 A class that acts as a container for locked message objects.
 The purpose of this class is to allow up to 10 messages to be
 chained together inside of a single MSMessage.
 */

class lockedMessageContainer{

    var size: Int                                           // number of chained messages
    var sender: String                                    // the name of the sender of the message
    var isUsed: Bool                                     // the given message is used
    var uniqueId = -1                                  // assign a random id from 0-999,999 to the message
    var senderId: String                              // attach the senderId to the message
    var messageArray: [lockedMessageObject] = []     // array to hold the chained messages...
    var title: String
    
    init(){
        size = 1
        sender = "Sender"
        isUsed = false
        senderId = " "
        title = " "
        let temp = lockedMessageObject()
        messageArray.append(temp)
    }

    // function to set the values of a locked message from a MSMessage
    func initFromMessage(message: MSMessage?) {
        guard let messageURL = message?.url else { return  }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return  }
        let myRapper = queryItemRapper()
        myRapper.myQueries = queryItems
        setValues(qRapper: myRapper)
    }
    
    func setValues(qRapper: queryItemRapper){   // set from query items
        
        
        for queryItem in qRapper.myQueries{
            if queryItem.name == ("Z") {
                size = Int(queryItem.value!)!
            }
            else if queryItem.name == ("S") {
                sender = queryItem.value!
            }
            else if queryItem.name == ("I"){
                senderId = queryItem.value!
            }
            else if queryItem.name == ("U"){
                uniqueId = Int(queryItem.value!)!
            }
            else if queryItem.name == ("T"){
                title = queryItem.value!
            }
        }
        
        for i in 0..<size{
            let temp = lockedMessageObject()
            messageArray.append(temp)
            messageArray[i].setValues(ind: String(i), qRapper: qRapper)
        }
    }
    
    func writeValues() -> [URLQueryItem] { // write to query items
        let qRapper = queryItemRapper()
        
        for i in 0..<size{
            messageArray[i].writeValues(ind: String(i), qRapper: qRapper)
        }
        qRapper.myQueries.append(URLQueryItem(name: ("S"), value: sender))
        qRapper.myQueries.append(URLQueryItem(name: ("I"), value: senderId))
        qRapper.myQueries.append(URLQueryItem(name: ("U"), value: String(describing: uniqueId)))
        qRapper.myQueries.append(URLQueryItem(name: ("Z"), value: String(describing: size)))
        qRapper.myQueries.append(URLQueryItem(name: ("T"), value: title))
        return qRapper.myQueries
    }
    
    func setDefaults(index: String){ // write to defaults
        let defaults = UserDefaults.standard
        defaults.set(String(describing: size), forKey: index + "Sz")
        defaults.set(sender, forKey: index + "Sd")
        defaults.set(senderId, forKey: index + "SI")
        defaults.set(String(describing: uniqueId), forKey: index + "UI")
        defaults.set(String(describing: isUsed), forKey: index + "U")
        defaults.set(title, forKey: index + "T")
        for i in 0..<size{
            let address = index + "_" + String(describing: i) + "_"
            messageArray[i].setDefaults(ind: address)
        }
    }
    
    func getDefaults(index: String){ // get from defaults
        let defaults = UserDefaults.standard
        if let str = defaults.string(forKey: index + "Sz"){
            size = Int(str)!
        }
        if let str = defaults.string(forKey: index + "Sd"){
            sender = str
        }
        if let str = defaults.string(forKey: index + "SI"){
            senderId = str
        }
        if let str = defaults.string(forKey: index + "UI"){
            uniqueId = Int(str)!
        }
        if let str = defaults.string(forKey: index + "U"){
            isUsed = Bool(str)!
        }
        if let str = defaults.string(forKey: index + "T"){
            title = str
        }
        messageArray.removeAll()
        for i in 0..<size{
            let address = index + "_" + String(describing: i) + "_"
            let temp = lockedMessageObject()
            messageArray.append(temp)
            messageArray[i].getDefaults(ind: address)
        }
    }
    
    func clearDefaults(index: String){ // clear defaults for a lock
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: index + "Sz")
        defaults.removeObject(forKey: index + "Sd")
        defaults.removeObject(forKey: index + "SI")
        defaults.removeObject(forKey: index + "UI")
        defaults.removeObject(forKey: index + "U")
        defaults.removeObject(forKey: index + "T")
        for i in 0..<size{
            let address = index + "_" + String(describing: i) + "_"
            messageArray[i].clearDefaults(ind: address)
        }
    }
 
    func checkLock() -> Bool{
        for i in 0..<size{
            if(messageArray[i].isLocked){
                return true
            }
        }
        return false
    }
    
}
