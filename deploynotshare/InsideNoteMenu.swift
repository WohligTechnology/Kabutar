//
//  InsideNoteMenu.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/12/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class InsideNoteMenu: UIView {
    
    
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
        newDateTime = DateTime(frame: CGRectMake((width)-335, (height)-600, 300,500));
        self.window?.addSubview(newDateTime)
    }
    @IBAction func moveNote(sender: AnyObject) {
    }
    @IBAction func deleteNote(sender: AnyObject) {
    }
    @IBAction func shareNote(sender: AnyObject) {
    }
    
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (width), (height)))
        blackOut.backgroundColor = UIColor(red: 234, green: 0, blue: 0, alpha: 0.3)
    }
    
    func closeTimeBomb(sender:UIGestureRecognizer?){
        self.newDateTime.animation.makeY(height).easeInOut.animateWithCompletion(transitionTime, {
            self.newDateTime.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
