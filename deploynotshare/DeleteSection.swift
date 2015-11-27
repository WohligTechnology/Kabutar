//
//  DeleteSection.swift
//  deploynotshare
//
//  Created by Chintan Shah on 27/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class DeleteSection: UIView {
    
    var NoteElementID:Int64!
    var topView: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonTap(sender: AnyObject) {
        
        let editalert = UIAlertController(title: "Delete Section", message: "Are you sure you want to delete this section.", preferredStyle: UIAlertControllerStyle.Alert)
        let eidtcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            
        }
        let editesave = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            NoteElementModel.delete(self.NoteElementID)
            self.topView.removeFromSuperview()
        }
        editalert.addAction(eidtcancel)
        editalert.addAction(editesave)
       
        let controller = GDetailView 
        controller.presentViewController(editalert, animated: true) { () -> Void in
            
        }
    }
    
    func setID(id:Int64) {
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
        let nib = UINib(nibName: "DeleteSection", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }
}
