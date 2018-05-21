//
//  altitudeViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit

class altitudeViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate {
    
    static let storyboardIdentifier = "altitudeViewController"
    weak var delegate: altitudeViewControllerDelegate?
    
    let pickerData = [10, 100, 1000, 10000]
    var currentLock: altitudeLock?
    var msg: lockedMessageContainer?
    var curInd: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.altTol.dataSource = self;
        self.altTol.delegate = self;
        getRow()
        heightLabel.text = "\((currentLock?.altitude)!) ft"
        heightStepper.value = Double((currentLock?.altitude)!)
        heightStepper.wraps = true
        heightStepper.autorepeat = true
        heightStepper.minimumValue = 0
        heightStepper.maximumValue = 10000
        heightStepper.stepValue = 10
        mustLabel.text = currentLock?.getCondition()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRow(){
        if currentLock?.range == 0{
            currentLock?.range = 10
        }
        else if currentLock?.range == 10{
            altTol.selectRow(0, inComponent: 0, animated: true)
        }
        else if currentLock?.range == 100{
            altTol.selectRow(1, inComponent: 0, animated: true)
        }
        else if currentLock?.range == 1000{
            altTol.selectRow(2, inComponent: 0, animated: true)
        }
        else if currentLock?.range == 10000{
            altTol.selectRow(3, inComponent: 0, animated: true)
        }
    }
    
    @IBOutlet weak var mustLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var heightStepper: UIStepper!
    
    @IBOutlet weak var altTol: UIPickerView!
   
    @IBAction func stepperValChange(_ sender: UIStepper) {
        heightLabel.text = Int(sender.value).description + " ft"
        currentLock?.altitude = Int(sender.value)
        mustLabel.text = currentLock?.getCondition()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row]) ft"
    }
    
    @IBAction func selectNo(_ sender: UIButton) {
        currentLock?.isLocked = false
        currentLock?.isUsed = 0
        delegate?.delFuncAVCD(self, msg: msg!, ind: curInd!)
    }
    
    @IBAction func selectYes(_ sender: UIButton) {
        currentLock?.isLocked = true
        currentLock?.isUsed = 1
        delegate?.delFuncAVCD(self, msg: msg!, ind: curInd!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentLock?.range = pickerData[row]
        mustLabel.text = currentLock?.getCondition()
    }
}

protocol altitudeViewControllerDelegate: class {
    func delFuncAVCD(_ controller: altitudeViewController, msg: lockedMessageContainer, ind: Int)
}
