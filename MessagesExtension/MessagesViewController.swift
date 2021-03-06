//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Matthew Mccrackin on 7/31/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit
import Messages
import MapKit

class MessagesViewController: MSMessagesAppViewController {
    
    // flags
    var toSaved = false
    var toChest = false
    var toCreate = false
    var toView = false
    var toViewLock = false
    var toCrackPin = false
    var toNo = false
    var toYes = false
    var toLoc = false
    var toTime = false
    var toPin = false
    var toTemp = false
    var toAlt = false
    var toWeath = false
    var setB = false
    var editView = false
    var toDelete = false
    var toSave = false
    var toSettings = false
    
    
    // objects and index
    var myMessage = lockedMessageContainer()
    var myController: UIViewController?
    var currentInd: Int?
    var mySlot: Int?                        // current message slot in container
    var myCoord = CLLocationCoordinate2D()
    
    // MARK: - Conversation Handling
    
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        super.willBecomeActive(with: conversation)
        presentViewController(for: conversation, with: presentationStyle)
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        super.willTransition(to: presentationStyle)

        // get rid of the all the child views :)
        removeAllChildViewControllers()
    
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        super.didTransition(to: presentationStyle)
        // Use this method to finalize any behaviors associated with the change in presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    }

    fileprivate func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
       
        // Remove any child view controllers that have been presented.
        removeAllChildViewControllers()
        

        
        // see if the current user has an id, if not create one
        let userdefaults = UserDefaults.standard
        var yourId: String
        if let receiverId = userdefaults.string(forKey: "SenderId"){
            yourId = receiverId
        }
        else{
            let a = String(arc4random_uniform(1000))     // get a random string from 0-999
            let b = String(arc4random_uniform(1000000)) // get a random string from 0-999999
            userdefaults.set(a + b, forKey: "SenderId")
            yourId = a + b
        }
    
        let checkMess = lockedMessageContainer()                               // create a new message
        checkMess.initFromMessage(message: conversation.selectedMessage)   // attempt to initialize message from active convo
        var chestKeys: [Int] = []                                         // create an array of chest keys
        var saveKeys: [Int] = []                                         // create an array of saved chest keys
        var isFound = false                                             // detected a hit with the message's key
        var size: Int
        
        // we're viewing a message from the converstion, that isn't default or from the current user
        if(!toChest && !toSaved && checkMess.uniqueId != -1 ){
            
            var tempMess = lockedMessageContainer()
            if let chestSize = userdefaults.string(forKey: "ChestCount"){ // get the number of chest messages
                size = Int(chestSize)!
            }
            else{
                size = -1
                userdefaults.set(-1, forKey: "ChestCount")
            }
            if(size >= 0){
                for i in 0..<size + 1{
                    tempMess.getDefaults(index: ("Chest" + String(describing: i)))
                    chestKeys.append(tempMess.uniqueId)
                }
            }
            if let saveSize = userdefaults.string(forKey: "SaveCount"){ // repeat for the saved messages
                size = Int(saveSize)!
            }
            else{
                size = -1
                userdefaults.set(-1, forKey: "SaveCount")
            }
            if(size >= 0){
                for i in 0..<size + 1{
                    tempMess.getDefaults(index: ("Save" + String(describing: i)))
                    saveKeys.append(tempMess.uniqueId)
                }
            }
            var isInChest = true
            
            for i in chestKeys{
                if i == checkMess.uniqueId{ // compare the received message id with the chest array
                    isFound = true
                }
            }
            
            if !isFound{
                for i in saveKeys{
                    if i == checkMess.uniqueId{ // compare the received message id with the saved message array
                        isFound = true
                        isInChest = false
                    }
                }
            }
            
            if (isFound == false) && yourId != checkMess.senderId{                                // the key is unique, so we can add it to the message chest and view it
                let count: Int                          // to the store the current count in a chest
                if let inChest = userdefaults.string(forKey: "ChestCount"){ // we were able to load a value
                    if(Int(inChest)! < 0){count = 0}
                    else{ // otherwise, increment the counter to goto the next index
                        count = Int(inChest)! + 1
                    }
                }
                else{
                    count = 0 // we couldn't grab the stored count, so set it to having one
                }
             //   userdefaults.set(checkMess.uniqueId, forKey: "Chest\(count)ID")
                userdefaults.set(count, forKey: "ChestCount")  // store the new value for chestCount
                checkMess.isUsed = true
                checkMess.setDefaults(index: "Chest" + String(describing: count)) // set the defaults for the index
                myMessage = checkMess
                guard let controller = storyboard?.instantiateViewController(withIdentifier: viewMessController.storyboardIdentifier) as? viewMessController else { fatalError("Unable to instantiate View Message")}
                controller.msg = myMessage
                controller.delegate = self
                controller.isSaved = false
                controller.curInd = count
                controller.curSlot = 0
                myController = controller // now shift to viewing the received message...
            }
            else if (yourId != checkMess.senderId){
                var type = "Chest"
                if(isInChest == false){
                    type = "Save"
                }
                var counter: Int
                var findMess = lockedMessageContainer()
                if let tempV = userdefaults.string(forKey: type + "Count"){ // we were able to load a value
                    counter = Int(tempV)!
                    for i in 0..<counter + 1{
                        findMess.getDefaults(index: type + String(describing: i))
                        if(findMess.uniqueId == checkMess.uniqueId){
                            guard let controller = storyboard?.instantiateViewController(withIdentifier: viewMessController.storyboardIdentifier) as? viewMessController else { fatalError("Unable to instantiate View Message")}
                            controller.msg = myMessage
                            controller.delegate = self
                            controller.isSaved = !isInChest
                            controller.curInd = i
                            controller.curSlot = 0
                            break
                        }
                    }
                }
                
                
            }
            else{
                checkLogic(with: presentationStyle)
            }
        }
    
        else {
            checkLogic(with: presentationStyle)
        }
        
        // Embed the new controller.
      
        addChildViewController(myController!)
        
        myController?.view.frame = view.bounds
        myController?.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview((myController?.view)!)
        
        NSLayoutConstraint.activate([
            (myController?.view.leftAnchor.constraint(equalTo: view.leftAnchor))!,
            (myController?.view.rightAnchor.constraint(equalTo: view.rightAnchor))!,
            (myController?.view.topAnchor.constraint(equalTo: view.topAnchor))!,
            (myController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor))!,
            ])
        
        myController?.didMove(toParentViewController: self)
 
    }
    
    // function to remove child views
    fileprivate func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
    
    // Get to implement all the logic for the menus now.... YAY!   :|
    
    private func checkLogic(with presentationStyle: MSMessagesAppPresentationStyle){ // call all the checks
        

        if(toSettings) // we're on the way to settings, so open that view
        {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: settingsViewController.storyboardIdentifier) as? settingsViewController else { fatalError("Unable to instantiate Settings View")}
            controller.delegate = self
            myController = controller
        }

        
            
            
        else if(toCreate){ // check for new lock creation
            if(checkLocCreate(with: presentationStyle)){} // check for new lock types
            else if(checkAltCreate(with: presentationStyle)){}
            else if(checkTimeCreate(with: presentationStyle)){}
            else if(checkPinCreate(with: presentationStyle)){}
            else if(checkTempCreate(with: presentationStyle)){}
            else if(checkWeathCreate(with: presentationStyle)){}
            else{                                                   // we aren't shifting to a new lock type, so shift to new message
                toCreate = false
                guard let controller = storyboard?.instantiateViewController(withIdentifier: newMessageViewController.storyboardIdentifier) as? newMessageViewController else { fatalError("Unable to instantiate New Message View")}
                
                controller.msg = myMessage
                controller.curInd = mySlot
                controller.presentationStyle = presentationStyle
                controller.delegate = self
                myController = controller
            }
        }
            
            
        else if(toView){ // we need to shift the the view message controller
            toCreate = false
            if (toChest || toSaved){ // the shift is coming from one of the chests
                if(toLoc){checkLocCreate(with: presentationStyle)} // are we going to check a location?
                else if(toPin){checkPinCreate(with: presentationStyle)} // are we going to check a pin?
                else{   // otherwise, we might be viewing the message
                    guard let controller = storyboard?.instantiateViewController(withIdentifier: viewMessController.storyboardIdentifier) as? viewMessController else { fatalError("Unable to instantiate View Message")}
                    let type: String
                    if(toSaved){type = "Save"} // fetch the type of chest
                    else{type = "Chest"}
                    if mySlot == nil{
                        mySlot = 0
                    }
                    let mess = lockedMessageContainer()
                    mess.getDefaults(index: type + String(describing:currentInd!)) // now get the values
                    controller.msg = mess
                    controller.delegate = self
                    controller.curInd = currentInd
                    controller.curSlot = mySlot
                    controller.isSaved = toSaved
                    myController = controller
                }

            }
        }
        
        
        
        
        else if toChest || toSaved{ // we're going to the saved chest or regular
            guard let controller = storyboard?.instantiateViewController(withIdentifier: chestSavedController.storyboardIdentifier) as? chestSavedController else { fatalError("Unable to instantiate Chest")}
            
            let mess = lockedMessageContainer()
            controller.myMess = mess
            controller.isSavedChest = toSaved
            controller.delegate = self
            myController = controller
        }
        else{
            initMain(with: presentationStyle)
        }
    }
    

    // initialize the main view
    private func initMain(with presentationStyle: MSMessagesAppPresentationStyle){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: chestSavedController.storyboardIdentifier) as? chestSavedController else { fatalError("Unable to instantiate Main Create View")}
        controller.delegate = self
        controller.isSavedChest = false
        myMessage = lockedMessageContainer()
        controller.myMess = myMessage
        myController = controller
    }
    
    // goto locationViewController when toLoc1 or toLoc2
    private func checkLocCreate(with presentationStyle: MSMessagesAppPresentationStyle) -> Bool{
        if toLoc{
            
            toLoc = false
            if(!editView && (toSaved || toChest)){
                guard let controller = storyboard?.instantiateViewController(withIdentifier: viewLocationController.storyboardIdentifier) as? viewLocationController else { fatalError("Unable to instantiate View Location")}
                controller.msg = myMessage
                if !(setB){
                    controller.currentLock = myMessage.messageArray[mySlot!].rowA.location
                }
                else{
                    controller.currentLock = myMessage.messageArray[mySlot!].rowB.location
                }
                controller.curSlot = mySlot
                controller.myIndex = currentInd
                controller.delegate = self
                controller.fromSaved = toSaved
                controller.currentLocation = myCoord
                myController = controller
                return true
            }
                
                
            else{
                guard let controller = storyboard?.instantiateViewController(withIdentifier: locationViewController.storyboardIdentifier) as? locationViewController else { fatalError("Unable to instantiate Location Create View")}
                if !(setB){
                    controller.currentLock = myMessage.messageArray[mySlot!].rowA.location
                }
                else{
                    controller.currentLock = myMessage.messageArray[mySlot!].rowB.location
                }
                controller.delegate = self
                controller.msg = myMessage
                controller.curInd = mySlot
                myController = controller
                return true
            }
        }
        return false
    }
    
    // goto timeViewControler when toTime1 or toTime2
    private func checkTimeCreate(with presentationStyle: MSMessagesAppPresentationStyle) -> Bool{
        if toTime{
            guard let controller = storyboard?.instantiateViewController(withIdentifier: timeViewController.storyboardIdentifier) as? timeViewController else { fatalError("Unable to instantiate Time Create View")}

            controller.msg = myMessage
            controller.curInd = mySlot
            toTime = false
            if !(setB){
                controller.currentLock = myMessage.messageArray[mySlot!].rowA.time
            }
            else{
                controller.currentLock = myMessage.messageArray[mySlot!].rowB.time
            }
            controller.delegate = self
            myController = controller
            return true
        }
        return false
    }
    
    // goto pinViewController when toPin1 or toPin2
    private func checkPinCreate(with presentationStyle: MSMessagesAppPresentationStyle) -> Bool{
        if toPin{
            toPin = false
            if(!editView && (toSaved || toChest)){
                guard let controller = storyboard?.instantiateViewController(withIdentifier: viewPinController.storyboardIdentifier) as? viewPinController else { fatalError("Unable to instantiate View PIN")}
                controller.msg = myMessage
                controller.myIndex = currentInd
                if !(setB){
                    controller.currentLock = myMessage.messageArray[mySlot!].rowA.pin
                }
                else{
                    controller.currentLock = myMessage.messageArray[mySlot!].rowB.pin
                }
                controller.delegate = self
                controller.curSlot = mySlot
                controller.fromSaved = toSaved
                myController = controller
                return true
            }
            else{
                guard let controller = storyboard?.instantiateViewController(withIdentifier: pinViewController.storyboardIdentifier) as? pinViewController else { fatalError("Unable to instantiate Pin Create View")}
                controller.msg = myMessage
                if !(setB){
                    controller.currentLock = myMessage.messageArray[mySlot!].rowA.pin
                }
                else{
                    controller.currentLock = myMessage.messageArray[mySlot!].rowB.pin
                }
                controller.delegate = self
                controller.curInd = mySlot
                myController = controller
                return true
            }
        }
        return false
    }
    
    // goto tempViewController when toTemp1 or toTemp2
    private func checkTempCreate(with presentationStyle: MSMessagesAppPresentationStyle) -> Bool{
        if toTemp{
            toTemp = false
            guard let controller = storyboard?.instantiateViewController(withIdentifier: tempViewController.storyboardIdentifier) as? tempViewController else { fatalError("Unable to instantiate Temp Create View")}
            controller.msg = myMessage
            if !(setB){
                controller.currentLock = myMessage.messageArray[mySlot!].rowA.temp
            }
            else{
                controller.currentLock = myMessage.messageArray[mySlot!].rowB.temp
            }
            controller.delegate = self
            controller.curInd = mySlot
            myController = controller
            return true
        }
        return false
    }
    
    // goto altViewController when toAlt1 or toAlt2
    private func checkAltCreate(with presentationStyle: MSMessagesAppPresentationStyle) -> Bool{
        if toAlt{
            toAlt = false
            guard let controller = storyboard?.instantiateViewController(withIdentifier: altitudeViewController.storyboardIdentifier) as? altitudeViewController else { fatalError("Unable to instantiate Altitude Create View")}
            controller.msg = myMessage
            if !(setB){
                controller.currentLock = myMessage.messageArray[mySlot!].rowA.altitude
            }
            else{
                controller.currentLock = myMessage.messageArray[mySlot!].rowB.altitude
            }
            controller.delegate = self
            controller.curInd = mySlot
            myController = controller
            return true
        }
        return false
    }
    
    // goto weatherViewController when toWeath1 or toWeath2
    private func checkWeathCreate(with presentationStyle: MSMessagesAppPresentationStyle) -> Bool{
        if toWeath{
            toWeath = false
            guard let controller = storyboard?.instantiateViewController(withIdentifier: weatherViewController.storyboardIdentifier) as? weatherViewController else { fatalError("Unable to instantiate Weather Create View")}
            controller.msg = myMessage
            if !(setB){
                controller.currentLock = myMessage.messageArray[mySlot!].rowA.weather
            }
            else{
                controller.currentLock = myMessage.messageArray[mySlot!].rowB.weather
            }
            controller.delegate = self
            controller.curInd = mySlot
            myController = controller
            return true
        }
        return false
    }
    
    
    
    fileprivate func composeMessage(with mess: lockedMessageContainer, caption: String, session: MSSession? = nil) -> MSMessage {
        var components = URLComponents()

        components.queryItems = mess.writeValues()
        let layout = MSMessageTemplateLayout()
       // layout.image = iceCream.renderSticker(opaque: true)
        layout.caption = caption
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    
    
    fileprivate func shiftHelper(with presentationStyle: MSMessagesAppPresentationStyle, msg: lockedMessageContainer){
        myMessage = msg
        removeAllChildViewControllers()
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    }
    
}

// need to implement delegates for each type of view change...

extension MessagesViewController: newMessageviewControllerDelegate{
    func delFuncNMVCD(_ controller: newMessageViewController, with presentationStyle: MSMessagesAppPresentationStyle, msg: lockedMessageContainer, createV: Bool, backF: Bool,row2: Bool, loc: Bool, time: Bool, temp: Bool, pin: Bool, weather: Bool, alt: Bool, snd: Bool, currentSlot: Int) {
        
        if(snd){
            guard let conversation = activeConversation else { fatalError("Expected a conversation") }
            let message = composeMessage(with: msg, caption: "You received a new locked message!")
            conversation.insert(message) { error in
                if let error = error {
                    print(error)
                }
            }
            dismiss()
        }
        
        else if (backF){
        }
        
        else{
            toCreate = true
            editView = true
            setB = row2
            toLoc = loc
            toTime = time
            toAlt = alt
            toPin = pin
            toWeath = weather
            toTemp = temp
            myMessage = msg
            mySlot = currentSlot
        }
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: viewMessControllerDelegate{
    func delFuncNMVCD(_ controller: viewMessController,  msg: lockedMessageContainer, backF: Bool, row2: Bool, loc: Bool, pin: Bool, isSaved: Bool, currCoord: CLLocationCoordinate2D, ind: Int, slot: Int) {
        
        if(backF){
            if(isSaved){
                toSaved = true
            }
            toChest = !toSaved
            toView = false
            myMessage = lockedMessageContainer()
            mySlot = 0
        }
    
        else{
            if(isSaved){
                toSaved = true
            }
            else{
                toChest = true
            }
            toView = true
            toLoc = loc
            setB = row2
            myCoord = currCoord
            toPin = pin
            myMessage = msg
            currentInd = ind
            mySlot = slot
        }
        
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: chestSavedControllerDelegate{
    func delFuncCSVCD(_ controller: chestSavedController,msg: lockedMessageContainer, index: Int, isSaved: Bool, toNew: Bool, toSettings: Bool) {
        if(toNew){
            toCreate = true
            mySlot = 0
        }
        else if (toSettings){
            self.toSettings = true
        }
        else if(index == 51){
            toSaved = false
            toChest = false
            toCreate = false
            shiftHelper(with: presentationStyle, msg: myMessage)
        }
        else{
            myMessage = msg
            currentInd = index
            toView = true
            toSaved = isSaved
            toChest = !isSaved
            currentInd = index
        }
        
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: viewLocationControllerDelegate{
    func delFuncVLCD(_ controller: viewLocationController, msg: lockedMessageContainer, fromSaved: Bool, index: Int, curSlot: Int) {
        if(fromSaved){
            toSaved = true
        }
        else{
          //  toChest = true
        }
        toView = true
        myMessage = msg
        currentInd = index
        mySlot = curSlot
        shiftHelper(with: presentationStyle, msg: msg)
    }
}


extension MessagesViewController: locationViewControllerDelegate{
    func delFuncLVCD(_ controller: locationViewController, msg: lockedMessageContainer, ind: Int) {
        toCreate = true
        mySlot = ind
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: timeViewControllerDelegate{
    func delFuncTVCD(_ controller: timeViewController, msg: lockedMessageContainer, ind: Int) {
        toCreate = true
        mySlot = ind
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: viewPinControllerDelegate {
    func delFuncVPCD(_ controller: viewPinController, msg: lockedMessageContainer, fromSaved: Bool, index: Int, curSlot: Int){
        if(fromSaved){
            toSaved = true
        }
        else{
            //toChest = true
        }
        toView = true
        myMessage = msg
        currentInd = index
        mySlot = curSlot
        shiftHelper(with: presentationStyle, msg: msg)
    }
}


extension MessagesViewController: pinViewControllerDelegate{
    func delFuncPVCD(_ controller: pinViewController, msg: lockedMessageContainer, ind: Int) {
        toCreate = true
        mySlot = ind
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: weatherViewControllerDelegate{
    func delFuncWVCD(_ controller: weatherViewController, msg: lockedMessageContainer, ind: Int) {
        toCreate = true
        mySlot = ind
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: altitudeViewControllerDelegate{
    func delFuncAVCD(_ controller: altitudeViewController, msg: lockedMessageContainer, ind: Int) {
        toCreate = true
        mySlot = ind
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: tempViewControllerDelegate{
    func delFuncTeVCD(_ controller: tempViewController, msg: lockedMessageContainer, ind: Int) {
        toCreate = true
        mySlot = ind
        shiftHelper(with: presentationStyle, msg: msg)
    }
}

extension MessagesViewController: settingsViewControllerDelegate {
    func delFunc(_ controller: settingsViewController){
        toView = false
        toCreate = false
        toSaved = false
        toSettings = false
        let myMess = lockedMessageContainer()
        shiftHelper(with: presentationStyle, msg: myMess)
    }
}

