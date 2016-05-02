//
//  PasswordViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 28/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    
    @IBOutlet weak var firstbox: UITextField!
    @IBOutlet weak var secondbox: UITextField!
    @IBOutlet weak var thirdbox: UITextField!
    @IBOutlet weak var fourthbox: UITextField!
    @IBOutlet weak var passwordText: UILabel!
    
    @IBOutlet weak var buttonOne: UIButton!
    var lockValue = Int64()
    var setLock = String()
    var noteobj = Note()
    var titleName = String()
    var notesobj = Note()
    
//    @IBOutlet var PassView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordText.text = "Touch ID Enter Passcode"
        self.firstbox.layer.borderWidth = 1.0
        self.firstbox.layer.borderColor = UIColor.whiteColor().CGColor
        self.secondbox.layer.borderWidth = 1.0
        self.secondbox.layer.borderColor = UIColor.whiteColor().CGColor
        self.thirdbox.layer.borderWidth = 1.0
        self.thirdbox.layer.borderColor = UIColor.whiteColor().CGColor
        self.fourthbox.layer.borderWidth = 1.0
        self.fourthbox.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Do any additional setup after loading the view.
    }
    
    func deletePasscode(){
        if(self.fourthbox.text != ""){
            self.fourthbox.text = ""
        }else if(self.thirdbox.text != ""){
            self.thirdbox.text = ""
        }else if(self.secondbox.text != ""){
            self.secondbox.text = ""
        }else if(self.firstbox.text != ""){
            self.firstbox.text = ""
        }

    }
    

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "showdetaillistview"){
//            let vc = segue.destinationViewController as! detailViewController
//            vc.title = self.titleName
//            
//        }
//    }

    
    func checkPasscode(passcode:String){
        let realpasscode = config.get("passcode")
        if(realpasscode == passcode )
        {
            if(lockValue == 3){
                
                let noteView = config.get("note_view")
                switch(noteView) {
                case "1":
                    let otherCtrl = ViewForNotes as! Detailview;
                    otherCtrl.performSegueWithIdentifier("showdetaildetailview", sender: self)

                case "2":
                    let otherCtrl = ViewForNotes as! Listview;
                    otherCtrl.performSegueWithIdentifier("showdetaillistview", sender: self)

                case "3":
                    let otherCtrl = ViewForNotes as! cardViewController;
                    otherCtrl.performSegueWithIdentifier("showdetail", sender: self)
                default :
                    let otherCtrl = ViewForNotes as! Detailview;
                    otherCtrl.performSegueWithIdentifier("showdetaildetailview", sender: self)
                }
                dismissViewControllerAnimated(true, completion: nil)
            }else{
            if(lockValue == 0){
                if(self.setLock == "0"){
                    self.noteobj.changeLock(1, id2: selectedNoteId)
                }else{
                    self.noteobj.changeLock(0, id2: selectedNoteId)
                }
            }else{
                if(lockValue == -1){
                    print("in -1")
                    self.notesobj.delete(selectedNoteId)
                }else{
                if(self.setLock == "0"){
                    self.noteobj.changeLock(1, id2: selectedNoteId)
                }else{
                    self.noteobj.changeLock(0, id2: selectedNoteId)
                }
                }
            }
            
                let noteView = config.get("note_view")
                print(noteView)
                switch(noteView) {
                case "1":
                    let otherCtrl = ViewForNotes as! Detailview;
                    otherCtrl.getAllNotes()
                    otherCtrl.detailtableview!.reloadData()
                case "2":
                    let otherCtrl = ViewForNotes as! Listview;
                    otherCtrl.getAllNotes()
                      otherCtrl.listView!.reloadData()
                case "3":
                    let otherCtrl = ViewForNotes as! cardViewController;
                    otherCtrl.getAllNotes()
                    otherCtrl.collectionView!.reloadData()
                default :
                    let otherCtrl = ViewForNotes as! Detailview;
                    otherCtrl.getAllNotes()
                    otherCtrl.detailtableview!.reloadData()

                }
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error!", message: "Wrong Passcode !", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                
            }
            alert.addAction(alertAction)
            presentViewController(alert, animated: true) { () -> Void in }
            clearPass()
        }
    }
    var i = 0
    var pass = String()
    var confpass = String()
    
    func clearPass(){
        self.fourthbox.text = ""
        self.thirdbox.text = ""
        self.secondbox.text = ""
        self.firstbox.text = ""
    }
    
    func createPasscode(passcode:String)
    {
        
        if(i == 0){
            passwordText.text = "Confirm Password"
            pass = passcode
            clearPass()
            i = 1
        }else{
            confpass = passcode
            if(pass == confpass){
                config.set("passcode", value2: String(confpass))
                checkPasscode(confpass)
            }else{
                let alert = UIAlertController(title: "Error!", message: "Invalid Password !", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                    
                }
                alert.addAction(alertAction)
                presentViewController(alert, animated: true) { () -> Void in }
                i=0
                passwordText.text = "Touch ID Enter Passcode"
                clearPass()
            }
            
        }
    }
    
    func setPasscode(num:String){
        if(self.firstbox.text == ""){
            self.firstbox.text = num
        }else if(self.secondbox.text == ""){
            self.secondbox.text = num
        }else if(self.thirdbox.text == ""){
            self.thirdbox.text = num
        }else if(self.fourthbox.text == ""){
            self.fourthbox.text = num
            let passcode = self.firstbox.text! + self.secondbox.text! + self.thirdbox.text! + self.fourthbox.text!
            if(lockValue == 0){
                createPasscode(passcode)
            }else{
                checkPasscode(passcode)
            }
            
        }
    }

    @IBAction func oneClick(sender: AnyObject) {
        setPasscode("1")
    }
    @IBAction func twoClick(sender: AnyObject) {
        setPasscode("2")
    }
    @IBAction func threeClick(sender: AnyObject) {
        setPasscode("3")
    }
    @IBAction func fourClick(sender: AnyObject) {
        setPasscode("4")
    }
    @IBAction func fiveClick(sender: AnyObject) {
        setPasscode("5")
    }
    @IBAction func sixClick(sender: AnyObject) {
        setPasscode("6")
    }
    @IBAction func sevenClick(sender: AnyObject) {
        setPasscode("7")
    }
    @IBAction func eightClick(sender: AnyObject) {
        setPasscode("8")
    }
    @IBAction func nineClick(sender: AnyObject) {
        setPasscode("9")
    }
    @IBAction func zeroClick(sender: AnyObject) {
        setPasscode("0")
    }
    @IBAction func cancelClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func deleteClick(sender: AnyObject) {
        deletePasscode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
