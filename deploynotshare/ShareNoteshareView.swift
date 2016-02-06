//
//  ShareNoteshareView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 06/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit

class ShareNoteShareView: UIView {
    
    @IBOutlet var shareNoteshareEmail: UITextField!
    @IBOutlet var shareNoteshareCancel: UIButton!
    @IBOutlet var shareNoteshareOk: UIButton!
    
    @IBOutlet var sharenoteshareview: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("ShareNoteShareView", owner: self, options: nil)
        self.addSubview(self.sharenoteshareview)
    }

}
