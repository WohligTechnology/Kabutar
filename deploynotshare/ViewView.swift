//
//  ViewView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ViewView: UIView {

    @IBOutlet weak var viewpopup: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("ViewView", owner: self, options: nil)
        self.addSubview(self.viewpopup)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
