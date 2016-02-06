//
//  Settings.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit

class Settings: UIView {
    
    @IBOutlet var settings: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("Settings", owner: self, options: nil)
        self.addSubview(self.settings)
    }
    
}
