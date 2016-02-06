//
//  NotificationView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    @IBOutlet var notificationview: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("NotificationView", owner: self, options: nil)
        self.addSubview(self.notificationview)
    }
    
}
