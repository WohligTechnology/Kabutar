//
//  NoteFooterAdd.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class NoteFooterAdd: UIView {

    var newViewView:ViewView!
    var newSortView:SortView!
    var blackOut:UIView!
    
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
    }
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.window?.frame.width)!, (self.window?.frame.height)!))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    @IBAction func sortClick(sender: AnyObject) {
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeNewSortView:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        self.window?.addSubview(blackOut);
        newSortView = SortView(frame: CGRectMake(35, (self.window?.frame.height)!-350, (self.window?.frame.width)!-70,350));
        self.window?.addSubview(newSortView)
    }
    
    @IBAction func viewClick(sender: AnyObject) {
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeNewViewView:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        self.window?.addSubview(blackOut);
        newViewView = ViewView(frame: CGRectMake(35, (self.window?.frame.height)!-150, (self.window?.frame.width)!-70,150));
        self.window?.addSubview(newViewView)
    }
    
    func closeNewViewView (sender:UITapGestureRecognizer) {
        newViewView.removeFromSuperview()
        blackOut.removeFromSuperview()
    }
    
    
    func closeNewSortView (sender:UITapGestureRecognizer) {
        newSortView.removeFromSuperview()
        blackOut.removeFromSuperview()
    }
    

}
