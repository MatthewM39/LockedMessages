//
//  messageViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit

class messageViewController: UIViewController {

    static let storyboardIdentifier = "messageViewController"
    weak var delegate: messageViewControllerDelegate?
    
    var msg: lockedMessageObject?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var messageView: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
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
    
    @IBAction func loc1B(_ sender: UIButton) {
    }
    
    @IBAction func loc2B(_ sender: UIButton) {
    }
    
    @IBAction func time1B(_ sender: UIButton) {
    }
    
    @IBAction func time2B(_ sender: UIButton) {
    }
    
    @IBAction func pin1B(_ sender: UIButton) {
    }
    
    @IBAction func pin2B(_ sender: UIButton) {
    }
    
    @IBAction func weath1B(_ sender: UIButton) {
    }
    
    @IBAction func weath2B(_ sender: UIButton) {
    }
    
    @IBAction func temp1B(_ sender: UIButton) {
    }
    
    @IBAction func temp2B(_ sender: UIButton) {
    }
    
    @IBAction func alt1B(_ sender: UIButton) {
    }
    
    @IBAction func alt2B(_ sender: UIButton) {
    }
    
    
    
    
    
    
    @IBAction func saveMess(_ sender: UIButton) {
    }
    
    @IBAction func goBack(_ sender: Any) {
    }
    
    @IBAction func deleteButton(_ sender: Any) {
    }
}

protocol messageViewControllerDelegate: class {
    func delFuncMVCD(_ controller: messageViewController)
}

