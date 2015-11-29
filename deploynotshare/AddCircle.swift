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
        let checkstatus = config.get("note_view");
        let noteid = self.notesobj.createnoname("",background2: "background",color2: "10", folder2: 0, islocked2: 0,paper2: "",reminderTime2: 0,serverid2: "",tags2: "",timebomb2: 0)
        
        
        
        
        if(checkstatus == "2"){
            let mainview = ViewForNotes as! Listview
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            mainview.getselectedNote(noteid)
            mainview.performSegueWithIdentifier("showdetaillistview", sender: self)
        }else if(checkstatus == "1"){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            mainview.getselectedNote(noteid)
            mainview.performSegueWithIdentifier("showdetaildetailview", sender: self)
        }else if(checkstatus == "3"){
            let mainview = ViewForNotes as! cardViewController
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
            mainview.getselectedNote(noteid)
            mainview.performSegueWithIdentifier("showdetail", sender: self)
        }
        else if(checkstatus == ""){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            mainview.getselectedNote(noteid)
            mainview.performSegueWithIdentifier("showdetaildetailview", sender: self)
        }
                
    }
}
