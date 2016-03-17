//
//  ShareNoteshareView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 06/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit

class ShareNoteShareView: UIView {
    
    @IBOutlet weak var shareCancel: UIButton!
    @IBOutlet weak var shareOk: UIButton!
    @IBOutlet weak var shareEmail: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ShareNoteShareView", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        sortnewview.frame = bounds
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
    }
    @IBAction func shareCancelAction(sender: AnyObject) {
//        blackOut.removeFromSuperview();
    }
    @IBAction func shareOkAction(sender: AnyObject) {
        let noteShareEmails = shareEmail.text
        //let shareEmailSeperator = noteShareEmails!.componentsSeparatedByString(",")
        print(noteShareEmails)
    }
}
