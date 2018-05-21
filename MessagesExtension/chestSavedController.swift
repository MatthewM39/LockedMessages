//
//  chestSavedController.swift
//  lockedMessages
//
//  Created by Matthew Mccrackin on 8/2/17.
//  Copyright © 2017 Matthew Mccrackin. All rights reserved.
//

import UIKit
import Messages

class chestSavedController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")!
        let text = chest[indexPath.row].title
        var lockStatus = " "
        if(!chest[indexPath.row].checkLock()){
            lockStatus = "✅"
        }
        else{
            lockStatus = "🔒"
        }
        
        cell.textLabel?.text = lockStatus + text + " -" + chest[indexPath.row].sender
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.delFuncCSVCD(self, msg: myMess!, index: indexPath.row, isSaved: isSavedChest!, toNew: false, toSettings: false)
    }
    
    
    static let storyboardIdentifier = "chestSavedController"
    weak var delegate: chestSavedControllerDelegate?

    
    var isSavedChest: Bool?                      // flag passed if the view needs to be the saved chest
    var chest: [lockedMessageContainer] = []       // array for the chest of messages
    var myMess: lockedMessageContainer?           // to pass the tapped message into view
    var page1: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        page1 = true
        if (isSavedChest)!{
            myLabel.text = "Saved Chest"
            //typeButton.setTitle("To Message Chest", for: .normal)
            refresh(type: "Save")
        }
        else{
            myLabel.text = "Message Chest" // make the title Message Chest
            refresh(type: "Chest")
        }
        roundify()
        messageTable.dataSource = self
        messageTable.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var arrowButton: UIButton!
    
    @IBOutlet weak var myLabel: UILabel!

    @IBAction func settingsClick(_ sender: UIButton) {
        myMess = lockedMessageContainer()
        delegate?.delFuncCSVCD(self, msg: myMess!, index: -1, isSaved: false, toNew: false, toSettings: true)
    }
    
    
    @IBAction func newClick(_ sender: UIButton) {
        myMess = lockedMessageContainer()
        delegate?.delFuncCSVCD(self, msg: myMess!, index: -1, isSaved: false, toNew: true, toSettings: false)
    }
    
    @IBAction func typeClick(_ sender: UIButton) {
        isSavedChest = !isSavedChest!
        if(isSavedChest)!{
          //  typeButton.setTitle("To Message Chest", for: .normal)
            myLabel.text = "Saved Chest"
            refresh(type: "Save")
        }
        else{
         //   typeButton.setTitle("To Saved Chest", for: .normal)
            myLabel.text = "Message Chest" // make the title Message Chest
            refresh(type: "Chest")
        }
        messageTable.reloadData()
    }
    
    
    func checkArrow() -> Bool{
        if arrowButton.titleLabel?.text == "Next Page"{    // returns true while on the first page
            return true
        }
        return false
    }
    
    
    
    func refresh(type: String){
        chest.removeAll()               // need to clear the container of loaded chests
        let defaults = UserDefaults.standard
        var size: Int
        if let x = defaults.string(forKey: type + "Count"){     // try to load the number of messages
            size = Int(x)!
        }
        else{
            defaults.set( -1, forKey: type + "Count") // we couldn't load from defaults, so give it one
            return
        }
        if(size < 0){return}
        for i in 0...size{
            let cur = lockedMessageContainer() // make a locked message
            cur.getDefaults(index: type + String(describing: i)) // fetch its data
            if cur.isUsed{  // make sure the lock is used to be safe
                chest.append(cur)
            }
        }
        checkView()
    }
    
    
    @IBOutlet weak var newButton: UIButton!
    
    @IBOutlet weak var typeButton: UIButton!
    
    @IBOutlet weak var messageTable: UITableView!
    
    func checkView(){
        if(chest.count < 1){
            messageTable.isHidden = true
        }
        else{
            messageTable.isHidden = false
        }
    }
    
    func roundify(){
        newButton.layer.cornerRadius = 5
        typeButton.layer.cornerRadius = 5
    }
}

protocol chestSavedControllerDelegate: class {
    func delFuncCSVCD(_ controller: chestSavedController,msg: lockedMessageContainer, index: Int, isSaved: Bool, toNew: Bool, toSettings: Bool)
}

