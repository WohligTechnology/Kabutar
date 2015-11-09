//
//  DetailViewFooterMain.swift
//  deploynotshare
//
//  Created by Chintan Shah on 09/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class DetailViewFooterMain: UIView {

 
    
    @IBAction func addTextTap(sender: AnyObject) {
        GDetailView.addTextTap();
    }
    
    @IBAction func addImageTap(sender: AnyObject) {
        GDetailView.addImageTap();
    }
    
  
    @IBAction func addSketchTap(sender: AnyObject) {
        GDetailView.addSketchTap();
    }
   
    @IBAction func addAudioTap(sender: AnyObject) {
        GDetailView.addAudioTap();
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
