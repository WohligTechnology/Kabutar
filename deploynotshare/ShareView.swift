//
//  ShareView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit


@IBDesignable class ShareView: UIView {
    
    @IBOutlet var shareNoteshare: UIButton!
    @IBOutlet var shareText: UIButton!
    @IBOutlet var shareSreenshot: UIButton!
    @IBOutlet var shareUrl: UIButton!
    
    @IBOutlet var shareview: UIView!
    var note = ""
    var emaillist = UITextField()
    
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
        let nib = UINib(nibName: "ShareView", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        sortnewview.frame = bounds
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
    }
    
    
    
    @IBAction func shareViaNoteshare(sender: AnyObject) {
//        print(checkstatus);
        let createalert = UIAlertController(title: "Share Note", message: "Emails to Share", preferredStyle: UIAlertControllerStyle.Alert)
        let createcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        let createsave = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print(self.emaillist.text);
            print(selectedNoteId)
//            self.folderobj.create(self.createfolsername.text!)
//            self.viewDidLoad()
        }
        createalert.addAction(createcancel)
        createalert.addAction(createsave)
        createalert.addTextFieldWithConfigurationHandler { shareemaillist -> Void in
            shareemaillist.placeholder = "Enter email(,)"
            self.emaillist = shareemaillist
        }
        let mainview = ViewForNotes as! Listview
        mainview.presentViewController(createalert, animated: true) { () -> Void in
            
        }
    }
    
    func shareViaText() {}
    
    func shareViaSreenshot () {}
    
    func shareViaUrl () {}
    
}
