//
//  SecurityViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 16/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController {

    @IBOutlet weak var oldPasscode: UITextField!
    @IBOutlet weak var confirmPasscode: UITextField!
    @IBOutlet weak var newPasscode: UITextField!
    @IBOutlet weak var setPassword: UIStackView!
    @IBOutlet weak var changePassword: UIStackView!
    @IBOutlet weak var firstConfirm: UITextField!
    @IBOutlet weak var firstPassword: UITextField!
    var configPassword = config.get("passcode2")
    var checkOldPass = 0
    var checkNewPass = 0
    var storeNewPass = ""

    let limitLength = 10
//    let old
    override func viewDidLoad() {


        super.viewDidLoad()


        if(configPassword == ""){
            print("cassword blanck")
            setPassword.hidden = false
            changePassword.hidden = true
            self.firstPassword.becomeFirstResponder()
        }else{
            changePassword.hidden = false
            setPassword.hidden = true
            self.oldPasscode.becomeFirstResponder()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func messagePopup(){
        let editalert = UIAlertController(title: "Security", message: "Invalid Password", preferredStyle: UIAlertControllerStyle.Alert)
        let eidtcancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.oldPasscode.becomeFirstResponder()
            self.checkOldPass = 0
        }
        editalert.addAction(eidtcancel)
        presentViewController(editalert, animated: true) { () -> Void in
            
        }
    }
    
    
    @IBAction func changeTextNewPassword(sender: AnyObject) {
        let newValLen = newPasscode.text?.characters.count
        
        if(newValLen >= 4)
        {
            checkNewPass = 1
            storeNewPass = newPasscode.text!
            confirmPasscode.becomeFirstResponder()
            
        }
    }
    
    @IBAction func changeTextConfPassword(sender: AnyObject) {
        let newValLen = confirmPasscode.text?.characters.count
        
        if(newValLen >= 4)
        {
            if(checkOldPass == 1 && checkNewPass == 1){
                print("first check")
                if(storeNewPass == confirmPasscode.text!){
                    config.set("passcode", value2: confirmPasscode.text!)
                    dismissViewControllerAnimated(true, completion: nil)
                }else{
                    messagePopup()
                }
            }else{
                messagePopup()
            }
            
        }
    }
    @IBAction func changeTextOldPassword(sender: AnyObject) {
        let newValLen = oldPasscode.text?.characters.count
        
        if(newValLen >= 4)
        {
            print(configPassword)
            print(oldPasscode.text)
            if(configPassword == oldPasscode.text){
                newPasscode.becomeFirstResponder()
                checkOldPass = 1
            }else{
                messagePopup()
            }
            
            
        }
    }
    
    @IBAction func changeTextFirstPassword(sender: AnyObject) {
        let newValLen = firstPassword.text?.characters.count
        
        if(newValLen >= 4)
        {
            checkNewPass = 1
            storeNewPass = firstPassword.text!
            firstConfirm.becomeFirstResponder()
            
        }
        
    }
    
    @IBAction func changeTextFirstConfirm(sender: AnyObject) {
        let newValLen = firstConfirm.text?.characters.count
        
        if(newValLen >= 4)
        {
            if(checkNewPass == 1){
                if(storeNewPass == firstConfirm.text!){
                    config.set("passcode", value2: firstConfirm.text!)
                    dismissViewControllerAnimated(true, completion: nil)
                }else{
                    messagePopup()
                }
            }else{
                messagePopup()
            }
            
        }
    }
    
}
