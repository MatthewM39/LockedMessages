//
//  viewMessController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//
//

import UIKit
import MapKit

class viewMessController: UIViewController {
    
    @IBOutlet weak var subView: UIScrollView!
    static let storyboardIdentifier = "viewMessController"
    weak var delegate: viewMessControllerDelegate?
    var isSaved: Bool?
    var msg: lockedMessageContainer?
    let locationManager = CLLocationManager()
    var myWeather = wClimate(rawValue: "Snowing")
    var myTemp = 0
    var currentLocation = CLLocationCoordinate2D()
    var curInd: Int?
    var curSlot: Int?
    var type: String = ""
    
    func checkNav(){
        pageCounter.text = "\(String(describing:curSlot! + 1)) of \(String(describing: (msg?.size)!))"
        if curSlot == 0{
            prevB.setTitle("Current", for: .normal)
            prevB.alpha = 0.5
        }
        else{
            prevB.setTitle("Previous", for: .normal)
            prevB.alpha = 1
        }
        if msg?.size == curSlot! + 1{
            nextB.setTitle("Last", for: .normal)
            nextB.alpha = 0.5
        }
        else{
            nextB.setTitle("Next", for: .normal)
            nextB.alpha = 1
        }
        msg?.messageArray[curSlot!].checkLockStatus()
        checkIfUnlocked()
    }
    
    func roundify(){
        loc1.layer.cornerRadius = 5
        loc2.layer.cornerRadius = 5
        alt1.layer.cornerRadius = 5
        time1.layer.cornerRadius = 5
        pin1.layer.cornerRadius = 5
        weath1.layer.cornerRadius = 5
        temp1.layer.cornerRadius = 5
        alt2.layer.cornerRadius = 5
        time2.layer.cornerRadius = 5
        pin2.layer.cornerRadius = 5
        weath2.layer.cornerRadius = 5
        temp2.layer.cornerRadius = 5
        backB.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        delB.layer.cornerRadius = 5
        prevB.layer.cornerRadius = 5
        nextB.layer.cornerRadius = 5
        messLabel.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subView.contentSize = CGSize(width: self.view.frame.width , height: self.view.frame.height + 100)
        roundify()
        if(isSaved)!{
            type = "Save"
        }
        else{
            type = "Chest"
        }
        
        msg?.getDefaults(index: type + String(describing: curInd!))    // load the message from user defaults and index
        if(isSaved!){                               // if we're in the saved view, need to hide the save button...
            saveButton.isHidden = true
        }
        
        fromLabel.text = "From: " + (msg?.sender)!  // display sender of a message
        parseWeather()                              // parse the current weather data from OpenWeatherMap!
        checkIfUnlocked()                           // check if the message is unlocked
        checkNav()
        checkButtons()                              // set the buttons based off of the unlock status
    }
    
    @IBOutlet weak var messLabel: UITextView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Function that checks if the current message is unlocked.
    func checkIfUnlocked() -> Bool{
        if !((msg?.messageArray[curSlot!].isLocked))!{
            messLabel.text = (msg?.messageArray[curSlot!].myMessage)!
            return true
        }
        messLabel.text = "This message is currently locked! Unlock all of its locks in order to view the message!"
        return false
    }
    
    @IBOutlet weak var pageCounter: UILabel!
    
    @IBOutlet weak var orLabel: UILabel!
    
    
    @IBOutlet weak var prevB: UIButton!
    
    @IBOutlet weak var nextB: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var delB: UIButton!
    
    @IBOutlet weak var backB: UIButton!
    
    @IBOutlet weak var loc1: UIButton!
    
    @IBOutlet weak var loc2: UIButton!
    
    @IBOutlet weak var time1: UIButton!
    
    @IBOutlet weak var time2: UIButton!
    
    @IBOutlet weak var pin1: UIButton!
    
    @IBOutlet weak var pin2: UIButton!
    
    @IBOutlet weak var weath1: UIButton!
    
    @IBOutlet weak var weath2: UIButton!
    
    @IBOutlet weak var temp1: UIButton!
    
    @IBOutlet weak var temp2: UIButton!
    
    @IBOutlet weak var alt1: UIButton!
    
    @IBOutlet weak var alt2: UIButton!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var messageView: UITextView!
    
    @IBAction func backClick(_ sender: UIButton) {
        msg?.setDefaults(index: type + String(describing: curInd!))
        delegate?.delFuncNMVCD(self,  msg: msg!, backF: true, row2: false, loc: false, pin: false, isSaved: isSaved!, currCoord: currentLocation, ind: curInd!, slot: curSlot!)
    }
    
    // delete the current element and shift the others left
    func cleanStorage(index: Int, type: String, size: Int){
        if(size < 0){return}                                      // doesn't work out of bounds
        
        if(index == size){                                      // we're at the last slot so we can just clear it
            let myMess = lockedMessageContainer()                 // create a message from the defaults at a location
            myMess.clearDefaults(index: type + String(describing: size))     // now clear the slot
        }
            
        
        else if(index < size){                                 //  otherwise loop from current index to the last index
            for i in index..<size{
                let myMess = lockedMessageContainer()            // create a message from the defaults at a location
                myMess.getDefaults(index: type + String(describing:i + 1)) // load the defaults from the next element
                myMess.setDefaults(index: type + String(describing:i))    // write those defaults to the current element
            }
            let myMess = lockedMessageContainer()
            myMess.clearDefaults(index: type + String(describing:size)) // now clear the last element

        }
        
    }
    
    /*
     Moves a selected message from the regular chest to the saved chest. Cannot move a message if the save chest is
     full. In this case, a popup will be displayed warning the user. Moving a message removes it from the normal
     chest and shifts all other messages left 1. Changes the view to saved.
     */
    
    @IBAction func saveClick(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        var size: Int                                        // to store the number of saved messages
        if let x = defaults.string(forKey: "SaveCount"){    // attempt to load value from defaults
            size = Int(x)!
        }
        else{
            size = -1 // otherwise, we have none saved
        }
        if(size > 49){ // exceeded the max number of messages
            let alertController = UIAlertController(title: "Your Saved Chest is full!", message:
                "Delete some messages to free up space!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        else{ // otherwise index from 0-49
            msg?.setDefaults(index: "Save" + String(describing: size + 1)) // store in the next available index
            
            if let chestCount = defaults.string(forKey: "ChestCount"){ // try to subtract one from ChestCount
                if(curInd! >= 0){
                    cleanStorage(index: curInd!, type: "Chest", size: Int(chestCount)!)} // need to clean for more than one element
                defaults.set(size + 1, forKey: "SaveCount") // update count
                defaults.set(Int(chestCount)! - 1, forKey: "ChestCount")
            }
            else{
                defaults.set(-1, forKey: "ChestCount") // otherwise, initialize it to -1
            }

            
            
        }
        delegate?.delFuncNMVCD(self, msg: msg!, backF: true, row2: false, loc: false, pin: false, isSaved: true, currCoord: currentLocation, ind: curInd!, slot: curSlot!)
    }
    
    
    
    @IBAction func prevClick(_ sender: UIButton) {
        if curSlot == 0{
        }
        else{
            curSlot = curSlot! - 1
            checkButtons()
            checkNav()
        }
    }
    
    @IBAction func nextClick(_ sender: UIButton) {
        if curSlot == (msg?.size)! - 1{
        }
        else{
            curSlot = curSlot! + 1
            checkButtons()
            checkNav()
        }
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        var size: Int
        
        if let x = defaults.string(forKey: type + "Count"){      // attempt to get the selected count
            size = Int(x)!
        }
        else{
            size = -1       // failed to get count, abort
            return
        }
        cleanStorage(index: curInd!, type: type,size: size) // scrub the current message from the defaults
        defaults.set(size - 1, forKey: type + "Count")   // lower our size
        delegate?.delFuncNMVCD(self, msg: msg!, backF: true, row2: false, loc: false, pin: false, isSaved: isSaved!, currCoord: currentLocation, ind: curInd!, slot: curSlot!)
    }

    
    func clickLock(myAlert: String, status: Bool, desc: String, cur: Lock){
        let str: String
        if(status){
            str = "LOCKED "
        }
        else{
            str = "UNLOCKED "
        }
        let description = desc
        let alertController = UIAlertController(title: str + myAlert, message:
            description, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        msg?.messageArray[curSlot!].checkLockStatus()
        checkIfUnlocked()
        checkButtons() // refresh the buttons
    }

    
    @IBAction func loc1Click(_ sender: UIButton) {
        msg?.setDefaults(index: type + String(describing: curInd!))
        delegate?.delFuncNMVCD(self,  msg: msg!, backF: false, row2: false, loc: true, pin: false, isSaved: isSaved!, currCoord: currentLocation, ind: curInd!, slot: curSlot!)
    }
    
    @IBAction func loc2Click(_ sender: UIButton) {
        msg?.setDefaults(index: type + String(describing: curInd!))
        delegate?.delFuncNMVCD(self,  msg: msg!, backF: false, row2: true, loc: true, pin: false, isSaved: isSaved!, currCoord: currentLocation, ind: curInd!, slot: curSlot!)
    }
    
    
    @IBAction func time1Click(_ sender: UIButton) {
        clickLock(myAlert: "Time Lock", status: (msg?.messageArray[curSlot!].rowA.time.checkLock())!, desc: (msg?.messageArray[curSlot!].rowA.time.getCondition())!, cur: (msg?.messageArray[curSlot!].rowA.time)!)
    }
    
    @IBAction func time2Click(_ sender: UIButton) {
        clickLock(myAlert: "Time Lock", status: (msg?.messageArray[curSlot!].rowB.time.checkLock())!, desc: (msg?.messageArray[curSlot!].rowB.time.getCondition())!, cur: (msg?.messageArray[curSlot!].rowB.time)!)
    }
    
    @IBAction func pin1Click(_ sender: UIButton) { // call a new view
        msg?.setDefaults(index: type + String(describing: curInd!))
        delegate?.delFuncNMVCD(self,  msg: msg!, backF: false, row2: false, loc: false, pin: true, isSaved: isSaved!, currCoord: currentLocation, ind: curInd!, slot: curSlot!)
    }
    
    @IBAction func pin2Click(_ sender: UIButton) { // call a new view
        msg?.setDefaults(index: type + String(describing: curInd!))
        delegate?.delFuncNMVCD(self,  msg: msg!, backF: false, row2: true, loc: false, pin: true, isSaved: isSaved!, currCoord: currentLocation, ind: curInd!, slot: curSlot!)
    }

    @IBAction func weath1Click(_ sender: UIButton) {
        clickLock(myAlert: "Weather Lock", status: (msg?.messageArray[curSlot!].rowA.weather.checkLock(wth: myWeather!))!, desc: ((msg?.messageArray[curSlot!].rowA.weather.getCondition())! + " It is currently " + (myWeather?.rawValue)! + "."), cur: (msg?.messageArray[curSlot!].rowA.weather)!)
    }

    @IBAction func weath2Click(_ sender: UIButton) {
        clickLock(myAlert: "Weather Lock", status: (msg?.messageArray[curSlot!].rowB.weather.checkLock(wth: myWeather!))!, desc: ((msg?.messageArray[curSlot!].rowB.weather.getCondition())! + " It is currently " + (myWeather?.rawValue)! + "."), cur: (msg?.messageArray[curSlot!].rowB.weather)!)
    }
    
    
    @IBAction func temp1Click(_ sender: UIButton) {
        clickLock(myAlert: "Temperature Lock", status: (msg?.messageArray[curSlot!].rowA.temp.checkLock(tmp: myTemp))!, desc: (msg?.messageArray[curSlot!].rowA.temp.getCondition())! + "  It is currently \(myTemp)°.", cur: (msg?.messageArray[curSlot!].rowA.temp)!)
    }
    
    
    @IBAction func temp2Click(_ sender: UIButton) {
        clickLock(myAlert: "Temperature Lock", status: (msg?.messageArray[curSlot!].rowB.temp.checkLock(tmp: myTemp))!, desc: (msg?.messageArray[curSlot!].rowB.temp.getCondition())! + "  It is currently \(myTemp)°.", cur: (msg?.messageArray[curSlot!].rowB.temp)!)
    }
    
    @IBAction func alt1Click(_ sender: UIButton) {
        let x = Int((locationManager.location?.altitude)! / 3)
        clickLock(myAlert: "Altitude Lock", status: (msg?.messageArray[curSlot!].rowA.altitude.checkLock(alt: x))!, desc: (msg?.messageArray[curSlot!].rowA.altitude.getCondition())! + " Current altitude is \(x) feet.", cur: (msg?.messageArray[curSlot!].rowA.altitude)!)
    }
    
    @IBAction func alt2Click(_ sender: UIButton) {
        let x = Int((locationManager.location?.altitude)! / 3)
        clickLock(myAlert: "Altitude Lock", status: (msg?.messageArray[curSlot!].rowB.altitude.checkLock(alt: x))!, desc: (msg?.messageArray[curSlot!].rowB.altitude.getCondition())! + " Current altitude is \(x) feet.", cur: (msg?.messageArray[curSlot!].rowB.altitude)!)
    }
    

    // unlocked locks are green
    func checkButton(butt: UIButton, lock: Lock){
        if(lock.isUsed > 0){
            butt.alpha = 1
            butt.isUserInteractionEnabled = true
            if(lock.isLocked){
                butt.backgroundColor = UIColor.blue
            }
            else{
                butt.backgroundColor = UIColor.green
            }
        }
        else{
            butt.isUserInteractionEnabled = false
            butt.alpha = 0.5
            butt.backgroundColor = UIColor.green
        }
    }
    
    // check each lock creation button
    func checkButtons(){
        checkButton(butt: alt1, lock: (msg?.messageArray[curSlot!].rowA.altitude)!)
        checkButton(butt: alt2, lock: (msg?.messageArray[curSlot!].rowB.altitude)!)
        checkButton(butt: loc1, lock: (msg?.messageArray[curSlot!].rowA.location)!)
        checkButton(butt: loc2, lock: (msg?.messageArray[curSlot!].rowB.location)!)
        checkButton(butt: pin1, lock: (msg?.messageArray[curSlot!].rowA.pin)!)
        checkButton(butt: pin2, lock: (msg?.messageArray[curSlot!].rowB.pin)!)
        checkButton(butt: temp1, lock: (msg?.messageArray[curSlot!].rowA.temp)!)
        checkButton(butt: temp2, lock: (msg?.messageArray[curSlot!].rowB.temp)!)
        checkButton(butt: weath1, lock: (msg?.messageArray[curSlot!].rowA.weather)!)
        checkButton(butt: weath2, lock: (msg?.messageArray[curSlot!].rowB.weather)!)
        checkButton(butt: time1, lock: (msg?.messageArray[curSlot!].rowA.time)!)
        checkButton(butt: time2, lock: (msg?.messageArray[curSlot!].rowB.time)!)
        checkOr()
    }

    func checkOr(){
        if(msg?.messageArray[curSlot!].rowB.isUsed == false){
            orLabel.alpha = 1
        }
        else{
            orLabel.alpha = 0.25
        }
    }
    
    
    func parseWeather(){
        locationManager.delegate = self     // get the user location
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        let apiKey = "http://api.openweathermap.org/data/2.5/weather?lat=\(Float(lat!))&lon=\(Float(long!))&appid=f7c73508fb0c6945c3e1935955f3f805"
        let url = URL(string: apiKey)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                self.extractWeather(weatherData: data!)     // extract the weather for the current user location
            })
        }
        currentLocation = CLLocationCoordinate2DMake(lat!, long!)
        task.resume()
    }
    
    func extractWeather(weatherData: Data){
       
        let weather = try? JSONSerialization.jsonObject(with:
            weatherData,
            options: .mutableContainers) as! [String: AnyObject]

        if weather != nil{
            
            let tempK = String(describing: (weather!["main"]!["temp"]!!))   // get the temp
            myTemp = Int((Double(tempK)! * (9/5)) - 460)                    // convert to Fahrenheit

            
            let weatherDict = (weather?["weather"]! as! NSArray)[0] as! [String: AnyObject]
            let weath = weatherDict["id"] as! Int

            if(weath >= 300 && weath < 600){        // set the weather based on the ID code parsed
                myWeather = wClimate.Rainy
            }
            else if ( weath >= 600 && weath <= 700){
                myWeather = wClimate.Snowing
            }
            else if ( weath >= 200 && weath < 300){
                myWeather = wClimate.Thundering
            }
            else if ( weath > 800 && weath < 810){
                myWeather = wClimate.Cloudy
            }
            else if ( weath == 800){
                myWeather = wClimate.Clear
            }
        }
    }
    
    
}

protocol viewMessControllerDelegate: class {
    func delFuncNMVCD(_ controller: viewMessController,  msg: lockedMessageContainer, backF: Bool,row2: Bool, loc: Bool, pin: Bool, isSaved: Bool, currCoord: CLLocationCoordinate2D, ind: Int, slot: Int)
}



extension viewMessController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            print("location:: (location)")
        }
        
    }
}
