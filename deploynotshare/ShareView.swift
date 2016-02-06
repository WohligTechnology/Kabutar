//
//  ShareView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit

class ShareView: UIView {
    
    @IBOutlet var shareNoteshare: UIButton!
    @IBOutlet var shareText: UIButton!
    @IBOutlet var shareSreenshot: UIButton!
    @IBOutlet var shareUrl: UIButton!
    
    @IBOutlet var shareview: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("ShareView", owner: self, options: nil)
        self.addSubview(self.shareview)
    }
    
    func shareViaNoteshare() {}
    
    func shareViaText() {}
    
    func shareViaSreenshot () {}
    
    func shareViaUrl () {}
    
}
