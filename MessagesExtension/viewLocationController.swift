//
//  viewLocationController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/7/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit
import MapKit

class viewLocationController: UIViewController {

    var myC: CLLocationCoordinate2D?
    static let storyboardIdentifier = "viewLocationController"
    weak var delegate: viewLocationControllerDelegate?
    var msg: lockedMessageContainer?
    var currentLock: locationLock?
    var currentLocation = CLLocationCoordinate2D()
    var fromSaved: Bool?
    var myIndex: Int?
    var isSaved: Bool?
    var curSlot: Int?
    override func viewWillAppear(_ animated: Bool) {
        mapView.layer.cornerRadius = 20
        closeB.layer.cornerRadius = 5
        myC = CLLocationCoordinate2DMake((currentLock?.lat)!, (currentLock?.long)!)
        let selectedPin = MKPlacemark.init(coordinate: myC!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedPin.coordinate
        annotation.title = "Lock Location"
        mapView.addAnnotation(annotation)
        
        let secondAnnotation = MKPointAnnotation()
        let selectedPin2 = MKPlacemark.init(coordinate: currentLocation)
        secondAnnotation.coordinate = selectedPin2.coordinate
        secondAnnotation.title = "Current Location"
        mapView.addAnnotation(secondAnnotation)
        
        conditionLabel.text = currentLock?.getCondition()
        if(currentLock?.isLocked)!{
            let cA = CLLocation(latitude: (myC?.latitude)!, longitude: (myC?.longitude)!)
            let cB = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let dist = cA.distance(from: cB)
            let inFeet = Int(dist / 3)
            if (currentLock?.checkLock(dist: inFeet))!{
                lockedLabel.text = "Locked"
            }
            else{
                lockedLabel.text = "Unlocked"
            }
            msg?.messageArray[curSlot!].checkLockStatus()
        }
        else{
            lockedLabel.text = "Unlocked"
        }
       

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var lockedLabel: UILabel!

    @IBOutlet weak var conditionLabel: UILabel!
  
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var closeB: UIButton!

    @IBAction func closeClick(_ sender: UIButton) {
        var type: String
        if fromSaved!{
            type = "Save"
        }
        else{
            type = "Chest"
        }
        
        msg?.setDefaults(index: type + String(describing:myIndex!))
        delegate?.delFuncVLCD(self, msg: msg!, fromSaved: fromSaved!, index: myIndex!, curSlot: curSlot!)
    }
}

protocol viewLocationControllerDelegate: class {
    func delFuncVLCD(_ controller: viewLocationController, msg: lockedMessageContainer, fromSaved: Bool, index: Int, curSlot: Int)
}
