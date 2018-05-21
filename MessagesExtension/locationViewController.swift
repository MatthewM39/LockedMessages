//
//  locationViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit
import MapKit

class locationViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate{
    
    static let storyboardIdentifier = "locationViewController"
    weak var delegate: locationViewControllerDelegate?
    let locationManager = CLLocationManager()
    var currentLock: locationLock?
    var msg: lockedMessageContainer?
    var curInd: Int?
    
    @IBOutlet weak var subView: UIScrollView!
    
    let pickerData = [100, 1000, 10000]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subView.contentSize = CGSize(width: self.view.frame.width , height: self.view.frame.height + 100)
        self.radLocation.dataSource = self
        self.radLocation.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.layer.cornerRadius = 20
        getRow()
        let x = currentLock?.radius
        myLabel.text = "Must be within \(x!) feet of current location."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRow(){
        if currentLock?.radius == 0{
            currentLock?.radius = 100
        }
        else if currentLock?.radius == 100{
            radLocation.selectRow(0, inComponent: 0, animated: true)
        }
        else if currentLock?.radius == 1000{
            radLocation.selectRow(1, inComponent: 0, animated: true)
        }
        else if currentLock?.radius == 10000{
            radLocation.selectRow(2, inComponent: 0, animated: true)
        }
    }
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var radLocation: UIPickerView!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!

    // code for PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row]) ft"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentLock?.radius = pickerData[row]
        let x = pickerData[row]
        myLabel.text = "Must be within \(x) feet of current location."
    }
    
    @IBAction func noClick(_ sender: UIButton) {
        currentLock?.isLocked = false
        currentLock?.isUsed = 0
        delegate?.delFuncLVCD(self,msg: msg!, ind: curInd!)
    }
    
    @IBAction func yesClick(_ sender: UIButton) {
        currentLock?.isLocked = true
        currentLock?.isUsed = 1
        currentLock?.long = (locationManager.location?.coordinate.longitude)!
        currentLock?.lat = (locationManager.location?.coordinate.latitude)!
        delegate?.delFuncLVCD(self, msg: msg!, ind: curInd!)
    }
    
}


extension locationViewController : CLLocationManagerDelegate {
    
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

protocol locationViewControllerDelegate: class {
    func delFuncLVCD(_ controller: locationViewController, msg: lockedMessageContainer, ind: Int)
}


