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
        innerColorView.alpha = 1.0
        innerColorView.frame.size.width = CGFloat(slideView.value)
        innerColorView.frame.size.height = CGFloat(slideView.value)
        self.innerColorView.center = CGPointMake(self.outerColorView.frame.size.width / 2, self.outerColorView.frame.size.height / 2);
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EraserView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        //view.frame = bounds
        view.center = CGPointMake(self.frame.size.width / 2,
                                                  self.frame.size.height / 2)
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        textValue.text = String(Int(GSketch.brushWidth))
        slideView.value = Float(GSketch.brushWidth)
        
        innerColorView.backgroundColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        print("CHECK@chck2 checks");
        print(GSketch.brushWidth)
        //        innerColorView.frame.size.width = GSketch.brushWidth
        //        innerColorView.frame.size.height = GSketch.brushWidth
        print(innerColorView.layer.frame.size)
        print(innerColorView.frame.size)
        innerColorView.frame.size = CGSize(width: 1, height: 1)
        
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2
        
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.resize(self.slideView);
            
        })
        
        
    }

}
