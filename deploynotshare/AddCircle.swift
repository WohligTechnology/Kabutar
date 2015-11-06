//
//  AddCircle.swift
//  
//
//  Created by Chintan Shah on 05/11/15.
//
//

import UIKit

class AddCircle: UIView {

    var view:UIView!;
    var notesobj = Note()
    var mainview = UIViewController()
    
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
        let nib = UINib(nibName: "AddCircle", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

    @IBAction func CreateNoteTap(sender: AnyObject) {
        switch(checkstatus){
        case 1: mainview = ViewForNotes as! Detailview;
        case 2: mainview = ViewForNotes as! Listview;
        case 3: mainview = ViewForNotes as! cardViewController;
        default : break
        }
//        let mainview = ViewForNotes as! cardViewController
        var createfolsername: UITextField!
        let createalert = UIAlertController(title: "Create Folder", message: "Folder name", preferredStyle: UIAlertControllerStyle.Alert)
        let createcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("cancel")
        }
        let createsave = UIAlertAction(title: "create", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.notesobj.create(createfolsername.text!,background2: "background",color2: "111", folder2: 1, islocked2: 1,paper2: "a",reminderTime2: 2,serverid2: "dfa",tags2: "tab",timebomb2: 0)
            self.mainview.viewDidLoad()
        }
        createalert.addAction(createcancel)
        createalert.addAction(createsave)
        createalert.addTextFieldWithConfigurationHandler { createfoldertext -> Void in
            createfoldertext.placeholder = "Folder name"
            createfolsername = createfoldertext
        }
        mainview.presentViewController(createalert, animated: true) { () -> Void in
            
        }
       
        
    }
}
