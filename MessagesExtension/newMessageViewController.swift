//
//  newMessageViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit
import CoreLocation
import Messages

class newMessageViewController: UIViewController, UITextViewDelegate {

    static let storyboardIdentifier = "newMessageViewController"
    weak var delegate: newMessageviewControllerDelegate?
    var presentationStyle: MSMessagesAppPresentationStyle?
    var msg: lockedMessageContainer?
    var curInd: Int?
    
    @IBOutlet weak var subView: UIScrollView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = "Enter your message here!"
        if msg?.title != " "{
            messTitle.text = msg?.title
        }
        checkNav()
        checkButtons()
        subView.contentSize = CGSize(width: self.view.frame.width , height: self.view.frame.height + 100)
    }
    
    func checkNav(){
        pageCounter.text = "\(String(describing: curInd! + 1)) of \(String(describing: (msg?.size)!))"
        if curInd == 0{
            prevB.setTitle("Current", for: .normal)
            prevB.alpha = 0.5
        }
        else{
            prevB.setTitle("Previous", for: .normal)
            prevB.alpha = 1
        }
        if msg?.size == 5 && curInd == 4{
            nextB.setTitle("Last", for: .normal)
            nextB.alpha = 0.5
        }
        else if (msg?.size)! - 1 == curInd!{
            nextB.setTitle("Add", for: .normal)
            nextB.alpha = 1
        }
        else{
            nextB.setTitle("Next", for: .normal)
            nextB.alpha = 1
        }
        if(msg?.messageArray[curInd!].myMessage == " "){
            textField.text = "Enter your message here!"
        }
        else{
            textField.text = msg?.messageArray[curInd!].myMessage
        }
    }
    
    func setRadii(){
        altB1.layer.cornerRadius = 5
        altB2.layer.cornerRadius = 5
        pinB1.layer.cornerRadius = 5
        pinB2.layer.cornerRadius = 5
        weathB1.layer.cornerRadius = 5
        weathB2.layer.cornerRadius = 5
        timeB1.layer.cornerRadius = 5
        timeB2.layer.cornerRadius = 5
        tempB1.layer.cornerRadius = 5
        tempB2.layer.cornerRadius = 5
        locB1.layer.cornerRadius = 5
        locB2.layer.cornerRadius = 5
        backB.layer.cornerRadius = 5
        sendB.layer.cornerRadius = 5
        textField.layer.cornerRadius = 5
        prevB.layer.cornerRadius = 5
        nextB.layer.cornerRadius = 5
        delB.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.textField.delegate = self
        setRadii()  // make the buttons pretty
        let defaults = UserDefaults.standard
        if let str = defaults.string(forKey: "SenderName"){
            msg?.sender = str
        }
        if let str = defaults.string(forKey: "SenderId"){
            msg?.senderId = str
        }
        else{
            let a = String(arc4random_uniform(1000))     // get a random string from 0-999
            let b = String(arc4random_uniform(1000000)) // get a random string from 0-999999
            defaults.set(a + b, forKey: "SenderId")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // set the color of a button based on its use status
    func checkButton(butt: UIButton, lock: Lock){
        if lock.isUsed > 0{
            butt.backgroundColor = UIColor.green
        }
        else{
            butt.backgroundColor = UIColor.clear
        }
    }
    
    // check each lock creation button
    func checkButtons(){
        checkButton(butt: altB1, lock: (msg?.messageArray[curInd!].rowA.altitude)!)
        checkButton(butt: altB2, lock: (msg?.messageArray[curInd!].rowB.altitude)!)
        checkButton(butt: locB1, lock: (msg?.messageArray[curInd!].rowA.location)!)
        checkButton(butt: locB2, lock: (msg?.messageArray[curInd!].rowB.location)!)
        checkButton(butt: pinB1, lock: (msg?.messageArray[curInd!].rowA.pin)!)
        checkButton(butt: pinB2, lock: (msg?.messageArray[curInd!].rowB.pin)!)
        checkButton(butt: tempB1, lock: (msg?.messageArray[curInd!].rowA.temp)!)
        checkButton(butt: tempB2, lock: (msg?.messageArray[curInd!].rowB.temp)!)
        checkButton(butt: weathB1, lock: (msg?.messageArray[curInd!].rowA.weather)!)
        checkButton(butt: weathB2, lock: (msg?.messageArray[curInd!].rowB.weather)!)
        checkButton(butt: timeB1, lock: (msg?.messageArray[curInd!].rowA.time)! )
        checkButton(butt: timeB2, lock: (msg?.messageArray[curInd!].rowB.time)!)
    }
    
    
    @IBOutlet weak var pageCounter: UILabel!
    
    // My buttons
    
    
    @IBOutlet weak var messTitle: UITextField!
    
    @IBOutlet weak var prevB: UIButton!
    
    @IBOutlet weak var nextB: UIButton!
    
    @IBOutlet weak var delB: UIButton!
    
    @IBOutlet weak var locB1: UIButton!
    
    @IBOutlet weak var locB2: UIButton!
    
    @IBOutlet weak var timeB1: UIButton!
    
    @IBOutlet weak var timeB2: UIButton!
    
    @IBOutlet weak var pinB1: UIButton!
    
    @IBOutlet weak var pinB2: UIButton!
    
    @IBOutlet weak var weathB1: UIButton!
    
    @IBOutlet weak var weathB2: UIButton!
    
    @IBOutlet weak var tempB1: UIButton!
    
    @IBOutlet weak var tempB2: UIButton!
    
    @IBOutlet weak var altB1: UIButton!
    
    @IBOutlet weak var altB2: UIButton!
    
    @IBOutlet weak var backB: UIButton!
    
    @IBOutlet weak var sendB: UIButton!

    
    @IBAction func prevClick(_ sender: UIButton) {
        if curInd == 0{
        }
        else{
             msg?.messageArray[curInd!].myMessage = textField.text
            curInd = curInd! - 1
           
            if msg?.messageArray[curInd!].myMessage == ""{
                msg?.messageArray[curInd!].myMessage = " "
            }
            if(msg?.messageArray[curInd!].myMessage == " "){
                textField.text = "Enter your message here!"
            }
            else{
                textField.text = msg?.messageArray[curInd!].myMessage
            }
            checkNav()
            checkButtons()
        }
    }
    
    
    @IBAction func nextClick(_ sender: UIButton) {
        if msg?.size == 5 && curInd == 4{
        }
        else if (msg?.size)! - 1 == curInd{
            msg?.messageArray[curInd!].myMessage = textField.text
            if msg?.messageArray[curInd!].myMessage == ""{
                msg?.messageArray[curInd!].myMessage = " "
            }

            curInd = curInd! + 1
            msg?.size = (msg?.size)! + 1
            let mess = lockedMessageObject()
            msg?.messageArray.append(mess)
            if(msg?.messageArray[curInd!].myMessage == " "){
                textField.text = "Enter your message here!"
            }
            else{
                textField.text = msg?.messageArray[curInd!].myMessage
            }
            checkNav()
            checkButtons()
        }
        else{
            msg?.messageArray[curInd!].myMessage = textField.text
            if msg?.messageArray[curInd!].myMessage == ""{
                msg?.messageArray[curInd!].myMessage = " "
            }
            curInd = curInd! + 1
            if(msg?.messageArray[curInd!].myMessage == " "){
                textField.text = "Enter your message here!"
            }
            checkNav()
            checkButtons()
        }
        
    }
    
    @IBAction func delClick(_ sender: UIButton) {
        if curInd == 0{
            if(msg?.size == 1){
                delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: false, backF: true, row2: false,  loc: false, time: false, temp: false, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)
            }
            else{
                msg?.messageArray.remove(at: curInd!)
                msg?.size = (msg?.size)! - 1
                checkNav()
                checkButtons()
            }
        }
        
        else{
            
            msg?.messageArray.remove(at: curInd!)
            if(curInd! == (msg?.size)! - 1){
                curInd = curInd! - 1
            }
            msg?.size = (msg?.size)! - 1
            checkNav()
            checkButtons()
        }
    }
    
    func loc1Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: false, loc: true, time: false, temp: false, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)
    }
    
    func temp1Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: false, loc: false, time: false, temp: true, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)

    }
    func time1Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: false,  loc: false, time: true, temp: false, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)

    }
    
    func pin1Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: false,  loc: false, time: false, temp: false, pin: true, weather: false, alt: false, snd: false, currentSlot: curInd!)

    }
    
    func weath1Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: false, loc: false, time: false, temp: false, pin: false, weather: true, alt: false, snd: false, currentSlot: curInd!)

    }
    
    
    func alt1Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: false, loc: false, time: false, temp: false, pin: false, weather: false, alt: true, snd: false, currentSlot: curInd!)

    }
    
    
    func loc2Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: true, loc: true, time: false, temp: false, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)
        
    }
    
    
    func time2Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: true, loc: false, time: true, temp: false, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)
    }
    
   func pin2Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: true, loc: false, time: false, temp: false, pin: true, weather: false, alt: false, snd: false, currentSlot: curInd!)
    }
    
    func weath2Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: true, loc: false, time: false, temp: false, pin: false, weather: true, alt: false, snd: false, currentSlot: curInd!)
    }
    
    func temp2Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: true, loc: false, time: false, temp: true, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)
    }
    
    func alt2Click(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        msg?.title = messTitle.text!
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: true, backF: false, row2: true, loc: false, time: false, temp: false, pin: false, weather: false, alt: true, snd: false, currentSlot: curInd!)
    }
    
    @IBOutlet weak var textField: UITextView!
    
    @IBAction func backClick(_ sender: UIButton) {
     delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: false, backF: true, row2: false,  loc: false, time: false, temp: false, pin: false, weather: false, alt: false, snd: false, currentSlot: curInd!)
        
    }
    
    
    
    @IBAction func clickSend(_ sender: UIButton) {
        msg?.messageArray[curInd!].myMessage = textField.text
        if msg?.messageArray[curInd!].myMessage == ""{
            msg?.messageArray[curInd!].myMessage = " "
        }
        if messTitle.text == ""{
            msg?.title = "Message"
        }
        else{
            msg?.title = messTitle.text!
        }
        
        for i in 0..<(msg?.messageArray.count)!{
            msg?.messageArray[i].rowA.checkUsed()
            msg?.messageArray[i].rowB.checkUsed()
            msg?.messageArray[i].checkLockStatus()
        }
        
        msg?.uniqueId = Int(arc4random_uniform(1000000))
        msg?.isUsed = true
        delegate?.delFuncNMVCD(self, with: presentationStyle!, msg: msg!, createV: false, backF: false, row2: false,  loc: false, time: false, temp: false, pin: false, weather: false, alt: false, snd: true, currentSlot: curInd!)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

protocol newMessageviewControllerDelegate: class {
    func delFuncNMVCD(_ controller: newMessageViewController, with presentationStyle: MSMessagesAppPresentationStyle, msg: lockedMessageContainer, createV: Bool, backF: Bool,row2: Bool, loc: Bool, time: Bool, temp: Bool, pin: Bool, weather: Bool, alt: Bool, snd: Bool, currentSlot: Int)
}
