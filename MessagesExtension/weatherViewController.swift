//
//  weatherViewController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/1/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit


class weatherViewController: UIViewController {
    
    static let storyboardIdentifier = "weatherViewController"
    weak var delegate: weatherViewControllerDelegate?
    
    var currentLock: weatherLock?
    var msg: lockedMessageContainer?
    var curInd: Int?
    
    @IBOutlet weak var clearB: UIButton!
    
    @IBOutlet weak var rainyB: UIButton!
    
    @IBOutlet weak var stormyB: UIButton!
    
    @IBOutlet weak var cloudyB: UIButton!
    
    @IBOutlet weak var snowyB: UIButton!
    
    func roundify(){
        clearB.layer.cornerRadius = 25
        rainyB.layer.cornerRadius = 25
        stormyB.layer.cornerRadius = 25
        cloudyB.layer.cornerRadius = 25
        snowyB.layer.cornerRadius = 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundify()
        swapSelected()
        weatherLabel.text = getWeather()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeather() ->String {
        return (currentLock?.myWeather.rawValue)!
    }
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBAction func sunnyB(_ sender: UIButton) {
        currentLock?.myWeather = wClimate.Clear
        swapSelected()
        weatherLabel.text = getWeather()
    }


    @IBAction func lightningB(_ sender: UIButton) {
        currentLock?.myWeather = wClimate.Thundering
        swapSelected()
        weatherLabel.text = getWeather()
    }

    @IBAction func cloudyB(_ sender: UIButton) {
        currentLock?.myWeather = wClimate.Cloudy
        swapSelected()
        weatherLabel.text = getWeather()
    }
    
    @IBAction func rainyB(_ sender: UIButton) {
        currentLock?.myWeather = wClimate.Rainy
        swapSelected()
        weatherLabel.text = getWeather()
    }
    
    @IBAction func snowB(_ sender: UIButton) {
        currentLock?.myWeather = wClimate.Snowing
        swapSelected()
        weatherLabel.text = getWeather()
    }
    
    @IBAction func selectNo(_ sender: UIButton) {
        currentLock?.isLocked = false
        currentLock?.isUsed = 0
        currentLock?.myWeather = wClimate.Clear
        delegate?.delFuncWVCD(self, msg: msg!, ind: curInd!)
    }
    
    @IBAction func selectYes(_ sender: UIButton) {
        currentLock?.isLocked = true
        currentLock?.isUsed = 1
        delegate?.delFuncWVCD(self, msg: msg!, ind: curInd!)
    }
    
    func swapSelected(){
        clearB.backgroundColor = UIColor.clear
        rainyB.backgroundColor = UIColor.clear
        cloudyB.backgroundColor = UIColor.clear
        stormyB.backgroundColor = UIColor.clear
        snowyB.backgroundColor = UIColor.clear
        if(currentLock?.myWeather == wClimate.Clear){
            clearB.backgroundColor = UIColor.green
        }
        else if(currentLock?.myWeather == wClimate.Rainy){
            rainyB.backgroundColor = UIColor.green
        }
        else if(currentLock?.myWeather == wClimate.Cloudy){
            cloudyB.backgroundColor = UIColor.green
        }
        else if(currentLock?.myWeather == wClimate.Thundering){
            stormyB.backgroundColor = UIColor.green
        }
        else{
            snowyB.backgroundColor = UIColor.green
        }
    }
    
}

protocol weatherViewControllerDelegate: class {
    func delFuncWVCD(_ controller: weatherViewController, msg: lockedMessageContainer, ind: Int)
}
