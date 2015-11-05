//
//  NoteCollectionUIView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class NoteCollectionUIView: UIView {

        var view:UIView!;

    @IBOutlet weak var timeLabel: UILabel!
  
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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
            let nib = UINib(nibName: "NoteCollectionViewCell", bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            view.frame = bounds
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.addSubview(view);
            
        }


}
