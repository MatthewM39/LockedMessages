//
//  timeViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit

class timeViewController: UIViewController {
    
    static let storyboardIdentifier = "timeViewController"
    weak var delegate: timeViewControllerDelegate?
    
    var currentLock: timeLock?
    var msg: lockedMessageContainer?
    var curInd: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = currentLock?.getCondition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeWheel: UIDatePicker!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func changeDay(_ sender: UIDatePicker) {
        currentLock?.lockDate = timeWheel.date
        dateLabel.text = currentLock?.getCondition()
    }
   
    
    @IBAction func selectNo(_ sender: UIButton) {
        currentLock?.isLocked = false
        currentLock?.isUsed = 0
        delegate?.delFuncTVCD(self, msg: msg!, ind: curInd!)
    }
    
    @IBAction func selectYes(_ sender: UIButton) {
        currentLock?.isLocked = true
        currentLock?.isUsed = 1
        delegate?.delFuncTVCD(self, msg: msg!, ind: curInd!)
    }
}

protocol timeViewControllerDelegate: class {
    func delFuncTVCD(_ controller: timeViewController, msg: lockedMessageContainer, ind: Int)
}

