//
//  ElementSketchFooter.swift
//  deploynotshare
//
//  Created by Chintan Shah on 11/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ElementSketchFooter: UIView {
    
    
    @IBAction func colorChange(sender: AnyObject) {
        GSketch.changeColor(0, blue2: 1, green2: 0)
    }
    @IBAction func brushChange(sender: AnyObject) {
        GSketch.changeColor(0.0,blue2: 0.0,green2: 0.0)
        GSketch.changeOpacity(1.0)
    }
    @IBAction func highlightChange(sender: AnyObject) {
        GSketch.changeColor(0.0, blue2: 0.0, green2: 0.0)
        GSketch.changeOpacity(0.4)
    }
    @IBAction func eraserChange(sender: AnyObject) {
        GSketch.changeColor(1.0, blue2: 1.0, green2: 1.0)
        GSketch.changeOpacity(1.0)
    }
    @IBAction func undoChange(sender: AnyObject) {
        GSketch.touchedUndo(sender)
    }
   
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
        let nib = UINib(nibName: "ElementSketchFooter", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view)
    }
}