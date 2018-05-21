//
//  tempViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit

class tempViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate  {
    
    static let storyboardIdentifier = "tempViewController"
    weak var delegate: tempViewControllerDelegate?
    
    let pickerData = [5,10,15,20]
    var currentLock: tempLock?
    var msg: lockedMessageContainer?
    var curInd: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        degreeLabel.text = "\((currentLock?.temp)!) °"
        degreeStepper.value = Double((currentLock?.temp)!)
        mustLabel.text = currentLock?.getCondition()
        self.tempTol.dataSource = self;
        self.tempTol.delegate = self;
        getRow()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRow(){
        if currentLock?.range == 0{
            currentLock?.range = 5
        }
        else if currentLock?.range == 5{
            tempTol.selectRow(0, inComponent: 0, animated: true)
        }
        else if currentLock?.range == 10{
            tempTol.selectRow(1, inComponent: 0, animated: true)
        }
        else if currentLock?.range == 15{
            tempTol.selectRow(2, inComponent: 0, animated: true)
        }
        else if currentLock?.range == 20{
            tempTol.selectRow(3, inComponent: 0, animated: true)
        }
        else if currentLock?.range == 25{
            tempTol.selectRow(4, inComponent: 0, animated: true)
        }
    }

    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var mustLabel: UILabel!
    @IBOutlet weak var tempTol: UIPickerView!
    @IBOutlet weak var degreeStepper: UIStepper!
    
    @IBAction func myStepper(_ sender: UIStepper) {
        currentLock?.temp = Int(sender.value)
        degreeLabel.text = Int(sender.value).description + "°"
        mustLabel.text = currentLock?.getCondition()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row]) °"
    }
    
    @IBAction func selectNo(_ sender: UIButton) {
        currentLock?.isLocked = false
        currentLock?.isUsed = 0
        delegate?.delFuncTeVCD(self, msg: msg!, ind: curInd!)
    }
    
    @IBAction func selectYes(_ sender: UIButton) {
        currentLock?.isLocked = true
        currentLock?.isUsed = 1
        delegate?.delFuncTeVCD(self, msg: msg!, ind: curInd!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentLock?.range = pickerData[row]
        mustLabel.text = currentLock?.getCondition()
    }
}

protocol tempViewControllerDelegate: class {
    func delFuncTeVCD(_ controller: tempViewController, msg: lockedMessageContainer, ind: Int)
}

