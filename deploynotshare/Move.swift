//
//  SortView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 28/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class Move: UIView {
    
    @IBOutlet var moveview: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("Move", owner: self, options: nil)
        self.addSubview(self.moveview)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
