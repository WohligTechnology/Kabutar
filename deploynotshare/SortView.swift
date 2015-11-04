//
//  SortView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 28/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class SortView: UIView {

    @IBOutlet var sortnewview: UIView!
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
