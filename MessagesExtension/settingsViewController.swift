//
//  settingsViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/5/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit
import Messages

class settingsViewController: UIViewController, UITextFieldDelegate {

    static let storyboardIdentifier = "settingsViewController"
    weak var delegate: settingsViewControllerDelegate?
    
    @IBOutlet weak var backB: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.nameBox.delegate = self
        backB.layer.cornerRadius = 5
       
        
        let defaults = UserDefaults.standard // initialize user defaults
        
        if let str = defaults.string(forKey: "SenderName"){
            nameBox.text = str // try to load user's name from defaults
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var nameBox: UITextField!
    
    @IBAction func nameChange(_ sender: UITextField) {
        let defaults = UserDefaults.standard
        defaults.set(nameBox.text, forKey: "SenderName") // text changed in user name box, so update the default
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        delegate?.delFunc(self) // we can return to the main menu now
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

protocol settingsViewControllerDelegate: class {
    func delFunc(_ controller: settingsViewController)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

