//
//  ElementImage.swift
//  deploynotshare
//
//  Created by Chintan Shah on 27/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ElementImage:UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var NoteElementID:Int64!
    var deleteView:DeleteSection!
    
    public func setID(id:Int64) {
        self.NoteElementID = id
    }
    
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
        let nib = UINib(nibName: "ElementImage", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        deleteView = DeleteSection(frame: CGRectMake(self.frame.size.width, 0, 30, 30))
        self.addSubview(deleteView)
        
    }
    
    func showDelete () {
        print(self.NoteElementID);
        deleteView.setID(self.NoteElementID)
        deleteView.topView = self
        deleteView.frame = CGRectMake(self.frame.size.width, 0, 30, 30)
        deleteView.animation.moveX(-30).animate(transitionTime)
        
    }
    func hideDelete() {
        deleteView.frame = CGRectMake(self.frame.size.width+10 - 30 , 0, 30, 30)
        deleteView.animation.moveX(30).animate(transitionTime)
    }

    
    
}
