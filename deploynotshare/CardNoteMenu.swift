//
//  InsideNoteMenu.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/12/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import SwiftyJSON
var noteInsideCard:CardNoteMenu!
var folderobj = Folder()
class CardNoteMenu: UIView {
    
    var notesobj = Note()
    var addMoveToFolder: MoveToFolder!
    var mainview = ViewForNotes as! cardViewController

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
        //        NSBundle.mainBundle().loadNibNamed("SortView", owner: self, options: nil)
        //        self.addSubview(self.sortnewview)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    var sortnewview: UIView!
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CardNoteMenu", bundle: bundle)
//        ViewForNotes = self
        noteInsideCard = self

        
        sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        //sortnewview.frame = bounds
        sortnewview.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
    }
    @IBAction func lockNote(sender: AnyObject) {
        
        self.removeFromSuperview()
        blackOut.removeFromSuperview()
        let oneNoteData = notesobj.findOne(Int64(selectedNoteId)!)
        print("in lock button")
        print(oneNoteData)
        
        let passcodemodal = mainview.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
        
        passcodemodal.setLock = String(oneNoteData![self.notesobj.islocked])
        
        let realpasscode = config.get("passcode")
        
        if(realpasscode == ""){
            passcodemodal.lockValue = 0
            mainview.presentViewController(passcodemodal, animated: true, completion: nil)
        }else{
            passcodemodal.lockValue = 1
            if(oneNoteData![self.notesobj.islocked] == 0){
                self.notesobj.changeLock(1,id2:(String)(oneNoteData![self.notesobj.id]))
            }else{
                mainview.presentViewController(passcodemodal, animated: true, completion: nil)
            }
        }
        
        //        sortnewview.removeFromSuperview()
        //        blackOut.removeFromSuperview()
        //        print("lock clicked")
        //        let passcodemodal = GDetailView.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
        //        passcodemodal.setLock = selectedLock
        //        print("selected note id" + selectedNoteId)
        //        print("selected lock" + selectedLock)
        //        let realpasscode = config.get("passcode")
        //        if(realpasscode == ""){
        //            passcodemodal.lockValue = 0
        //            GDetailView.presentViewController(passcodemodal, animated: true, completion: nil)
        //        }else{
        //            passcodemodal.lockValue = 1
        //            if(Int(selectedLock) == 0){
        //                notesobj.changeLock(1,id2:selectedNoteId)
        //            }else{
        //                GDetailView.presentViewController(passcodemodal, animated: true, completion: nil)
        //            }
        //        }
    }
    var addDateTimeView: DateTime!
    @IBAction func timebombOnNote(sender: AnyObject) {
        self.removeFromSuperview()
        blackOut.removeFromSuperview()
        innotepage = 0
        datetimepopupType = "timebomb"
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        mainview.view.addSubview(blackOut)
        blackOut.animation.makeAlpha(1).animate(transitionTime)
        addDateTimeView = DateTime(frame: CGRectMake(0 ,0, 300, 500))
        addDateTimeView.center = CGPointMake(mainview.view.frame.size.width / 2, mainview.view.frame.size.height / 2)
        mainview.view.addSubview(addDateTimeView)
    }
    var newDateTime: DateTime!
    @IBAction func reminderOnNote(sender: AnyObject) {
        self.removeFromSuperview()
        blackOut.removeFromSuperview()
        innotepage = 0
        datetimepopupType = "reminder"
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeRemainder:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        mainview.view.addSubview(blackOut)
        blackOut.animation.makeAlpha(1).animate(transitionTime)
        newDateTime = DateTime(frame: CGRectMake(0, 0, 300,300))
        newDateTime.center = CGPointMake(mainview.view.frame.size.width / 2, mainview.view.frame.size.width / 2)
        mainview.view.addSubview(newDateTime)
    }
    @IBAction func moveNote(sender: AnyObject) {
        
        self.removeFromSuperview()
        blackOut.removeFromSuperview()
        if(folderobj.countFolder() != 0){
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeMove:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        mainview.view.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        showMoveNote()
        }else{
            let editalert = UIAlertController(title: "Move", message: "No Folder Available.", preferredStyle: UIAlertControllerStyle.Alert)
            let eidtcancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
            }
            editalert.addAction(eidtcancel)
            
            mainview.presentViewController(editalert, animated: true) { () -> Void in
                
            }
        }
    }
    @IBAction func deleteNote(sender: AnyObject) {
        self.removeFromSuperview()
        blackOut.removeFromSuperview()
        showdeletenote()
    }
    var addShareView: ShareView!
    @IBAction func shareNote(sender: AnyObject) {
        print("on share notesss*******")
        if(!self.notesobj.isConnectedToNetwork()){
            print("empty y......")
            let alert = UIAlertController(title: "Alert", message: "Can not share this note without sync OR No Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            mainview.presentViewController(alert, animated: true) { () -> Void in }
        } else {
            if(config.isConfigNet()){
                
                self.notesobj.localtoserver{(json: JSON) -> () in
                    self.notesobj.servertolocal{(json: JSON) -> () in
                        //                            let onenote = self.notesobj.findOne(strtoll(selectedNoteId,nil,10));
                        //                            print(onenote)
                        //                            print(onenote![self.notesobj.serverid]!)
                        //                        self.noteobj.shareNote(onenote![self.noteobj.serverid]!, email: sendemailto, completion: self.resShareNote)
                    }
                }
            }
            
            blackOut.removeFromSuperview()
            let blackOutTap = UITapGestureRecognizer(target: self,action: "closeShare:")
            self.addBlackView()
            blackOut.addGestureRecognizer(blackOutTap)
            blackOut.alpha = 0
            mainview.view.addSubview(blackOut);
            blackOut.animation.makeAlpha(1).animate(transitionTime);
            addShareView = ShareView(frame: CGRectMake(0,0, width / 2 + 90, 200))
            addShareView.center = CGPointMake(mainview.view.frame.size.width / 2, mainview.view.frame.size.height / 2)
            mainview.view.addSubview(addShareView)
            self.removeFromSuperview()
        }
    }
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (mainview.view.frame.size.width), (mainview.view.frame.size.height)))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func closeRemainder(sender:UIGestureRecognizer?){
        newDateTime.animation.makeY(height).easeInOut.animateWithCompletion(transitionTime, {
            self.newDateTime.removeFromSuperview()
            blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
                blackOut.removeFromSuperview()
            })
        })
    }
    
    func closeTimeBomb(sender:UIGestureRecognizer?){
        addDateTimeView.animation.makeY(height).easeInOut.animateWithCompletion(transitionTime, {
            self.addDateTimeView.removeFromSuperview()
            blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
                blackOut.removeFromSuperview()
            })
        })
    }
    
    func closeMove(sender:UIGestureRecognizer?){
        addMoveToFolder.animation.makeY(height).easeInOut.animateWithCompletion(transitionTime, {
            self.addMoveToFolder.removeFromSuperview()
            blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
                blackOut.removeFromSuperview()
            })
        })
    }
    
    func closeShare(sender:UIGestureRecognizer?){
        addShareView.animation.makeY(height).easeInOut.animateWithCompletion(transitionTime, {
            self.addShareView.removeFromSuperview()
            blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
                blackOut.removeFromSuperview()
            })
        })
    }
    
    func showdeletenote(){
        let alert = UIAlertController(title: "Delete Note", message: "Are you sure !", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
        }
        let alertdelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("note id delete selected")
            print(selectedNoteId)
            self.notesobj.delete(selectedNoteId)
            self.mainview.navigationController?.popViewControllerAnimated(true)
            self.mainview.getAllNotes()
            self.mainview.collectionView.reloadData()
        }
        alert.addAction(alertAction)
        alert.addAction(alertdelete)
        mainview.presentViewController(alert, animated: true) { () -> Void in }
    }
    
    func showMoveNote() {
        addMoveToFolder = MoveToFolder(frame: CGRectMake(0, 0, 300, 250))
        addMoveToFolder.center = CGPointMake(mainview.view.frame.size.width / 2, mainview.view.frame.size.height / 2)
        mainview.view.addSubview(addMoveToFolder)
        //GDetailView.navigationController?.popViewControllerAnimated(true)
    }
    
}
