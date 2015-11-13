//
//  MessageView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 13/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class MessageView: UIView {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var messageText: UILabel!
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
        let nib = UINib(nibName: "MessageView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        messageText.text = "hello"
    }


}
