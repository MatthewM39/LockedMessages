//
//  pinViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit

class pinViewController: UIViewController {
    
    static let storyboardIdentifier = "pinViewController"
    weak var delegate: pinViewControllerDelegate?
    
    var counter = 0
    
    var currentLock: pinLock?
    var msg: lockedMessageContainer?
    var curInd: Int?
    var p1 = 0
    var p2 = 0
    var p3 = 0
    var p4 = 0
    
    @IBOutlet weak var subView: UIScrollView!
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
        bc.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {

        roundify()
        subView.contentSize = CGSize(width: self.view.frame.width , height: self.view.frame.height + 100)
        super.viewDidLoad()
        p1 = (currentLock?.first)!
        p2 = (currentLock?.second)!
        p3 = (currentLock?.third)!
        p4 = (currentLock?.fourth)!
        getCombo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func selectNo(_ sender: UIButton) {
        currentLock?.isLocked = false
        currentLock?.isUsed = 0
        delegate?.delFuncPVCD(self, msg: msg!, ind: curInd!)
    }
    
    @IBAction func selectYes(_ sender: UIButton) {
        currentLock?.isLocked = true
        currentLock?.isUsed = 1
        currentLock?.first = p1
        currentLock?.second = p2
        currentLock?.third = p3
        currentLock?.fourth = p4
        delegate?.delFuncPVCD(self, msg: msg!, ind: curInd!)
    }
    
    func getCombo(){
        myLabel.text  = "\(p1) \(p2) \(p3) \(p4)"
    }
    
    @IBOutlet weak var myLabel: UILabel!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
    }
    
    @IBAction func but1(_ sender: UIButton) {
        changeLabel(val: 1)
    }
    
    @IBAction func but2(_ sender: UIButton) {
         changeLabel(val: 2)
    }
    
    @IBAction func but3(_ sender: UIButton) {
         changeLabel(val: 3)
    }
    
    @IBAction func but4(_ sender: UIButton) {
         changeLabel(val: 4)
    }
    
    @IBAction func but5(_ sender: UIButton) {
         changeLabel(val: 5)
    }
    
    
    @IBAction func but6(_ sender: UIButton) {
         changeLabel(val: 6)
    }
    
    @IBAction func but7(_ sender: UIButton) {
         changeLabel(val: 7)
    }
    
    @IBAction func but8(_ sender: UIButton) {
         changeLabel(val: 8)
    }
    
    @IBAction func but9(_ sender: UIButton) {
         changeLabel(val: 9)
    }
    
    @IBAction func but0(_ sender: UIButton) {
         changeLabel(val: 0)
    }
    
    @IBAction func butClear(_ sender: UIButton) {
        counter = 0
        p1 = 0
        p2 = 0
        p3 = 0
        p4 = 0
        getCombo()
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
    @IBOutlet weak var bc: UIButton!
    
}

protocol pinViewControllerDelegate: class {
    func delFuncPVCD(_ controller: pinViewController, msg: lockedMessageContainer, ind: Int)
}

