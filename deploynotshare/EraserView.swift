//
//  EraserView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 13/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class EraserView: UIView {

    
    @IBOutlet weak var outerColorView: UIView!
    @IBOutlet weak var innerColorView: UIView!
    @IBOutlet weak var slideView: UISlider!
    @IBOutlet weak var textValue: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    @IBAction func resize(sender: UISlider) {
        GSketch.brushWidth = CGFloat(slideView.value)
        textValue.text = String(Int(slideView.value))
        innerViewSize = CGFloat(slideView.value)
        innerColorView.frame.size.width = CGFloat(slideView.value)
        innerColorView.frame.size.height = CGFloat(slideView.value)
        self.innerColorView.center = CGPointMake(self.outerColorView.frame.size.width / 2, self.outerColorView.frame.size.height / 2);
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EraserView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        textValue.text = String(Int(GSketch.brushWidth))
        slideView.value = Float(GSketch.brushWidth)
        
        innerColorView.frame.size.width = GSketch.brushWidth
        innerColorView.frame.size.height = GSketch.brushWidth
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2
    }

}
