//
//  DetailViewFooterMain.swift
//  deploynotshare
//
//  Created by Chintan Shah on 09/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class DetailViewFooterMain: UIView {

 
    
    @IBAction func deleteSectionTap(sender: AnyObject) {
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.deleteTap();
    }
    
    @IBAction func addTextTap(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addTextTap(true);
    }
    
    @IBAction func addImageTap(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addImageTap();
    }
    
  
    @IBAction func addSketchTap(sender: AnyObject) {
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addSketchTap();
    }
   
    @IBAction func addAudioTap(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addAudioTap(true);
    }
    
    @IBAction func addCheckBox(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addCheckBox(true);
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
        let nib = UINib(nibName: "DetailViewFooterMain", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }


}
