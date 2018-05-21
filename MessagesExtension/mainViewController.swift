//
//  mainViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/4/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit
import Messages

class mainViewController: UIViewController {

    static let storyboardIdentifier = "mainViewController"
    weak var delegate: mainViewControllerDelegate?
    var msg: lockedMessageObject?
    var presentationStyle: MSMessagesAppPresentationStyle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(presentationStyle == .expanded){ // check if we're expanded view
        maxLabel.text = " " // if so get rid of the label asking the user to maximize
        }
        newB.layer.cornerRadius = 15
        chestB.layer.cornerRadius = 15
        saveB.layer.cornerRadius = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var maxLabel: UILabel!

    
    @IBAction func newClick(_ sender: UIButton) { // goto new message menu
        delegate?.delFunc(self, with: presentationStyle!, msg: msg!, sendN: true, sendC: false, sendS: false)
    }
    
    @IBAction func chestClick(_ sender: UIButton) { // goto regular chest
        delegate?.delFunc(self, with: presentationStyle!, msg: msg!, sendN: false, sendC: true, sendS: false)
    }
    
    @IBAction func saveClick(_ sender: UIButton) { // goto saved chest
        delegate?.delFunc(self, with: presentationStyle!, msg: msg!, sendN: false, sendC: false, sendS: true)
    }
    
    @IBAction func toggleSettings(_ sender: UIButton) { // goto settings
        delegate?.delFunc(self, with: presentationStyle!, msg: msg!, sendN: true, sendC: true, sendS: true)
    }
    
    @IBOutlet weak var newB: UIButton!
    
    @IBOutlet weak var chestB: UIButton!
    
    @IBOutlet weak var saveB: UIButton!
}

protocol mainViewControllerDelegate: class {
    func delFunc(_ controller: mainViewController, with presentationStyle: MSMessagesAppPresentationStyle, msg: lockedMessageObject, sendN: Bool, sendC: Bool, sendS: Bool)
}
