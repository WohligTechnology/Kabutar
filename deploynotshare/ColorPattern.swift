//
//  ColorPattern.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 07/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ColorPattern: UIView {
    
    var noteobj = Note()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    func changeColorFunction(color:String){
        let checkstatus = config.get("note_view")
        
        if(checkstatus == "2"){
            let mainview = ViewForNotes as! Listview
            noteobj.changeColor(color,id2: ColorNote)
            mainview.getAllNotes()
            mainview.listView!.reloadData()
            mainview.closeColorPattern(nil);
            
        }else if(checkstatus == "1"){
            let mainview = ViewForNotes as! Detailview
            noteobj.changeColor(color,id2: ColorNote)
            mainview.getAllNotes()
            mainview.detailtableview!.reloadData()
            mainview.closeColorPattern(nil);
            
        }else if(checkstatus == "3"){
            noteobj.changeColor(color,id2: ColorNote)
            let mainview = ViewForNotes as! cardViewController
            
            mainview.closeColorPattern(nil);
            mainview.getAllNotes()
            mainview.collectionView!.reloadData()
            
        }
        
        self.removeFromSuperview()
    }
    
    @IBAction func firstColor(sender: AnyObject) {
        changeColorFunction(NoteColors[0])
        SelectedNoteColor = NoteColors[0]
    }
    @IBAction func secondColor(sender: AnyObject) {
        changeColorFunction(NoteColors[1])
        SelectedNoteColor = NoteColors[1]
    }
    @IBAction func thirdColor(sender: AnyObject) {
        changeColorFunction(NoteColors[2])
        SelectedNoteColor = NoteColors[2]
    }
    @IBAction func fourthColor(sender: AnyObject) {
        changeColorFunction(NoteColors[3])
        SelectedNoteColor = NoteColors[3]
    }
    @IBAction func fifthColor(sender: AnyObject) {
        changeColorFunction(NoteColors[4])
        SelectedNoteColor = NoteColors[4]
    }
    @IBAction func sixthColor(sender: AnyObject) {
        changeColorFunction(NoteColors[5])
        SelectedNoteColor = NoteColors[5]
    }
    @IBAction func seventhColor(sender: AnyObject) {
        changeColorFunction(NoteColors[6])
        SelectedNoteColor = NoteColors[6]
    }
    @IBAction func eighthColor(sender: AnyObject) {
        changeColorFunction(NoteColors[7])
        SelectedNoteColor = NoteColors[7]
    }
    @IBAction func ninthColor(sender: AnyObject) {
        changeColorFunction(NoteColors[8])
        SelectedNoteColor = NoteColors[8]
    }
    @IBAction func tenthColor(sender: AnyObject) {
        changeColorFunction(NoteColors[9])
        SelectedNoteColor = NoteColors[9]
    }
    @IBAction func defaultColor(sender: AnyObject) {
        changeColorFunction(NoteColors[10])
        SelectedNoteColor = NoteColors[10]
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ColorPattern", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        sortnewview.frame = bounds
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
        
    }

    
}
