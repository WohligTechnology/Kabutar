//
//  datetime.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class DateTime: UIView {
    @IBOutlet weak var datetimepopup: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    @IBAction func buttonOk(sender: AnyObject) {
       for view in datetimepopup.subviews{
                view.removeFromSuperview()
            }
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DateTime", bundle: bundle)
        let datetimepopup = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        datetimepopup.frame = bounds
        datetimepopup.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(datetimepopup);
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
