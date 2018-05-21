//
//  viewPinController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/7/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit

class viewPinController: UIViewController {

    static let storyboardIdentifier = "viewPinController"
    weak var delegate: viewPinControllerDelegate?
    var msg: lockedMessageContainer?
    var myIndex: Int?
    var fromSaved: Bool?
    var currentLock: pinLock?
    var counter = 0
    var p1 = 0
    var p2 = 0
    var p3 = 0
    var p4 = 0
    var curSlot: Int?
    
    func roundify(){
        b0.layer.cornerRadius = 5
        b1.layer.cornerRadius = 5
        b2.layer.cornerRadius = 5
        b3.layer.cornerRadius = 5
        b4.layer.cornerRadius = 5
        b5.layer.cornerRadius = 5
        b6.layer.cornerRadius = 5
        b7.layer.cornerRadius = 5
        b8.layer.cornerRadius = 5
        b9.layer.cornerRadius = 5
        bcl.layer.cornerRadius = 5
        bex.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundify()
        if(currentLock?.isLocked)!{
            lockStatus.text = "Locked"
            getCombo()
        }
        else{
            lockStatus.text = "Unlocked"
            p1 = (currentLock?.first)!
            p2 = (currentLock?.second)!
            p3 = (currentLock?.third)!
            p4 = (currentLock?.fourth)!
            getCombo()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getCombo(){
        currentPin.text = "\(p1) \(p2) \(p3) \(p4)"
    }

    func changeLabel(val: Int){
        switch (counter){
        case 0: p1 = val; counter += 1
        case 1: p2 = val; counter += 1
        case 2: p3 = val; counter += 1
        case 3: p4 = val; counter += 1
        default: break
        }
        getCombo()
        if !(currentLock?.checkLock(one: p1, two: p2, three: p3, four: p4))!{
            lockStatus.text = "Unlocked"
            msg?.messageArray[curSlot!].checkLockStatus()
            var type: String
            if(fromSaved)!{
                type = "Save"
            }
            else{
                type = "Chest"
            }
            msg?.setDefaults(index: type + String(describing: myIndex!))
        }
    }

    
    
    @IBOutlet weak var currentPin: UILabel!

    @IBOutlet weak var lockStatus: UILabel!
    
    @IBAction func click1(_ sender: UIButton) {
        changeLabel(val: 1)
    }
    
    @IBAction func click2(_ sender: UIButton) {
        changeLabel(val: 2)
    }
    
    @IBAction func click3(_ sender: UIButton) {
        changeLabel(val: 3)
    }
    
    @IBAction func click4(_ sender: UIButton) {
        changeLabel(val: 4)
    }
    
    @IBAction func click5(_ sender: UIButton) {
        changeLabel(val: 5)
    }
    
    @IBAction func click6(_ sender: UIButton) {
        changeLabel(val: 6)
    }
    
    @IBAction func click7(_ sender: UIButton) {
        changeLabel(val: 7)
    }
    
    @IBAction func click8(_ sender: UIButton) {
        changeLabel(val: 8)
    }
    
    @IBAction func click9(_ sender: UIButton) {
        changeLabel(val: 9)
    }
    
    @IBAction func click0(_ sender: UIButton) {
        changeLabel(val: 0)
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
        counter = 0
        p1 = 0
        p2 = 0
        p3 = 0
        p4 = 0
        getCombo()
    }
    
    @IBAction func clickClose(_ sender: UIButton) {
        delegate?.delFuncVPCD(self, msg: msg!, fromSaved: fromSaved!, index: myIndex!, curSlot: curSlot!)
    }
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    @IBOutlet weak var b9: UIButton!
    @IBOutlet weak var b0: UIButton!
    @IBOutlet weak var bcl: UIButton!
    @IBOutlet weak var bex: UIButton!
    
    
    
    

}

protocol viewPinControllerDelegate: class {
    func delFuncVPCD(_ controller: viewPinController, msg: lockedMessageContainer, fromSaved: Bool, index: Int, curSlot: Int)
}
