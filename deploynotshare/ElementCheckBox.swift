//
//  ElementCheckBox.swift
//  deploynotshare
//
//  Created by Chintan Shah on 09/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit



class ElementCheckBox: UIView,UITextFieldDelegate {

    var cb:Checkbox!
    @IBOutlet weak var checkBoxText: UITextField!
    public var NoteElementID:Int64!
    
    public func setID(id:Int64) {
        self.NoteElementID = id
    }
    @IBAction func textChange(sender: AnyObject) {
        print("Text Changes");
        print(checkBoxText.text);
        print(cb.isChecked)
        if(NoteElementID != nil)
        {
            NoteElementModel.edit(NoteElementID, content2 : checkBoxText.text! ,contentA2: String(cb.isChecked),contentB2: "")
        }
    }
    
    @IBAction func tapText(sender: AnyObject) {
        GElementCheckBox = self
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
        let nib = UINib(nibName: "ElementCheckBox", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
        cb = Checkbox(frame: CGRect(x: 10, y: 15, width: 20, height: 20))
        cb.mainElementCheckbox = self
        cb.borderColor = PinkColor
        cb.borderWidth = 1
        cb.checkColor = PinkColor
        cb.checkWidth = 3
        cb.checkboxText = checkBoxText
        self.addSubview(cb)
        
        
        
        
        checkBoxText.delegate = self
       
        //checkBoxText.becomeFirstResponder()
        
    }
    
  

    
}


