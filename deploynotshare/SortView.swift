//
//  SortView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 28/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class SortView: UIView {

    @IBOutlet weak var atoz: UIButton!
    @IBOutlet var sortnewview: UIView!
    
    @IBAction func sortAlpha(sender: AnyObject) {
        
        
        config.set("note_sort",value2: "1")
        if(checkstatus == 2){
            let mainview = ViewForNotes as! Listview
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            
        }else if(checkstatus == 1){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            
        }else if(checkstatus == 3){
            let mainview = ViewForNotes as! cardViewController
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
        }
        let newnoteFooter = noteFooter as! NoteFooterAdd
        newnoteFooter.closeNewSortView(nil)
    }
    
    @IBAction func sortColor(sender: AnyObject) {
        config.set("note_sort",value2: "2")
        if(checkstatus == 2){
            let mainview = ViewForNotes as! Listview
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            
        }else if(checkstatus == 1){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            
        }else if(checkstatus == 3){
            let mainview = ViewForNotes as! cardViewController
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
        }
        let newnoteFooter = noteFooter as! NoteFooterAdd
        newnoteFooter.closeNewSortView(nil)
    }
    
    @IBAction func sortCreation(sender: AnyObject) {
        config.set("note_sort",value2: "3")
        if(checkstatus == 2){
            let mainview = ViewForNotes as! Listview
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            
        }else if(checkstatus == 1){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            
        }else if(checkstatus == 3){
            let mainview = ViewForNotes as! cardViewController
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
        }
        let newnoteFooter = noteFooter as! NoteFooterAdd
        newnoteFooter.closeNewSortView(nil)    }
    
    @IBAction func sortModification(sender: AnyObject) {
        config.set("note_sort",value2: "4")
        if(checkstatus == 2){
            let mainview = ViewForNotes as! Listview
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            
        }else if(checkstatus == 1){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            
        }else if(checkstatus == 3){
            let mainview = ViewForNotes as! cardViewController
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
        }
        let newnoteFooter = noteFooter as! NoteFooterAdd
        newnoteFooter.closeNewSortView(nil)
    }
    
    @IBAction func sortReminder(sender: AnyObject) {
        config.set("note_sort",value2: "5")
        if(checkstatus == 2){
            let mainview = ViewForNotes as! Listview
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            
        }else if(checkstatus == 1){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            
        }else if(checkstatus == 3){
            let mainview = ViewForNotes as! cardViewController
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
        }
        let newnoteFooter = noteFooter as! NoteFooterAdd
        newnoteFooter.closeNewSortView(nil)
    }
    
    @IBAction func sortTimebomb(sender: AnyObject) {
        config.set("note_sort",value2: "6")
        if(checkstatus == 2){
            let mainview = ViewForNotes as! Listview
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            
        }else if(checkstatus == 1){
            let mainview = ViewForNotes as! Detailview
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            
        }else if(checkstatus == 3){
            let mainview = ViewForNotes as! cardViewController
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
        }
        let newnoteFooter = noteFooter as! NoteFooterAdd
        newnoteFooter.closeNewSortView(nil)
    }
    
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
        let nib = UINib(nibName: "SortView", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        sortnewview.frame = bounds
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
