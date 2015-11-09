//
//  NoteFooterAdd.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

var newViewView:ViewView!
var newSortView:SortView!
var blackOut:UIView!

var noteFooter:Any!

var transitionTime = 0.3

import UIKit
import DKChainableAnimationKit

class NoteFooterAdd: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
        
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NoteFooterAdd", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        noteFooter = self;
    }
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.window?.frame.width)!, (self.window?.frame.height)!))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    @IBAction func sortClick(sender: AnyObject) {
        
        
//        self.viewing.animation.makeOpacity(1.0).moveY(-1.height + viewing.frame.size.height).animateWithCompletion(0.30, {
//            self.shouldView=true
//            
//        })
        
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeNewSortView:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);

        newSortView = SortView(frame: CGRectMake(35, (self.window?.frame.height)!, (self.window?.frame.width)!-70,350));
        
        self.window?.addSubview(newSortView)
        newSortView.animation.moveY(-350).easeInOut.animate(transitionTime)

    }
    
    @IBAction func viewClick(sender: AnyObject) {
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeNewViewView:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        newViewView = ViewView(frame: CGRectMake(35,(self.window?.frame.height)!, (self.window?.frame.width)!-70,188));
        self.window?.addSubview(newViewView)
        newViewView.animation.moveY(-188).easeInOut.animate(transitionTime)
    }
    
    func closeNewViewView (sender:UITapGestureRecognizer?) {
        
        newViewView.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            newViewView.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })

        
    }
    
    
    func closeNewSortView (sender:UITapGestureRecognizer?) {
        newSortView.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            newSortView.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
        
    }

}
