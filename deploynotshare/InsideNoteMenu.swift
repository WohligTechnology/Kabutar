//
//  InsideNoteMenu.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/12/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class InsideNoteMenu: UIView {
    
    var notesobj = Note()
    var addMoveToFolder: MoveToFolder!
    var addDateTimeView:DateTime!
    
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
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "InsideNoteMenu", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        //sortnewview.frame = bounds
        sortnewview.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
    }
    @IBAction func lockNote(sender: AnyObject) {
    }
    @IBAction func timebombOnNote(sender: AnyObject) {
        datetimepopupType = "timebomb"
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        addDateTimeView = DateTime(frame: CGRectMake(width / 2 ,height / 2, 300, 800))
        addDateTimeView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        self.addSubview(addDateTimeView)
    }
    var newDateTime: DateTime!
    @IBAction func reminderOnNote(sender: AnyObject) {
        innotepage = 1
//        self.removeFromSuperview()
        datetimepopupType = "reminder"
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        newDateTime = DateTime(frame: CGRectMake((width)-335, (height)-600, 300,500))
        self.window?.addSubview(newDateTime)
    }
    @IBAction func moveNote(sender: AnyObject) {
        //self.removeFromSuperview()
        //showMoveNote()
    }
    @IBAction func deleteNote(sender: AnyObject) {
        self.removeFromSuperview()
        blackOut.removeFromSuperview()
        showdeletenote()
    }
    @IBAction func shareNote(sender: AnyObject) {
        if(!self.notesobj.isConnectedToNetwork()){
            print("empty y......")
            let alert = UIAlertController(title: "Alert", message: "Can not share this note without sync OR No Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            GDetailView.presentViewController(alert, animated: true) { () -> Void in }
            
        }else{
            let blackOutTap = UITapGestureRecognizer(target: self,action: "closeShareView:")
            self.addBlackView()
            blackOut.addGestureRecognizer(blackOutTap)
            blackOut.alpha = 0
            self.addSubview(blackOut);
            blackOut.animation.makeAlpha(1).animate(transitionTime);
            
            let addShareView = ShareView(frame: CGRectMake(0,0, width/2 + 90, 200))
            addShareView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
            self.addSubview(addShareView)
        }

    }
    
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (width), (height)))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func closeTimeBomb(sender:UIGestureRecognizer?){
        self.newDateTime.animation.makeY(height).easeInOut.animateWithCompletion(transitionTime, {
            self.newDateTime.removeFromSuperview()
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
            self.notesobj.delete(selectedNoteId)
            GDetailView.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(alertAction)
        alert.addAction(alertdelete)
        GDetailView.presentViewController(alert, animated: true) { () -> Void in }
    }
    
    func showMoveNote() {
        self.addMoveToFolder = MoveToFolder(frame: CGRectMake(MainWidth, MainHeight, 300, 250))
        self.addMoveToFolder.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        self.addSubview(self.addMoveToFolder)
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
