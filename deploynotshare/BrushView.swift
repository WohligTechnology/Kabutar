//
//  BrushView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 13/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//


import UIKit

class BrushView: UIView {
    
    @IBOutlet weak var textValue: UILabel!
    @IBOutlet weak var slideView: UISlider!
    @IBOutlet weak var outerColorView: UIView!
    @IBOutlet weak var innerColorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func changeAndClose(r:CGFloat, g:CGFloat, b:CGFloat){
        red = r;
        green = g;
        blue = b;
        
        GSketch.changeColor(r/255, green2: g/255, blue2: b/255)
        innerColorView.backgroundColor = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
        
        
//        GSketch.changeOpacity(0.4)
//        blackOut.removeFromSuperview()
//        brushView.removeFromSuperview()
        
    }
    func getColor() -> (CGFloat,CGFloat,CGFloat) {
        return (red,green,blue)
    }
    
    @IBAction func brushResize(sender: UISlider) {
        GSketch.brushWidth = CGFloat(slideView.value)
        textValue.text = String(Int(slideView.value))
        innerColorView.alpha = 1.0
        innerViewSize = CGFloat(slideView.value)
        innerColorView.frame.size.width = CGFloat(slideView.value)
        innerColorView.frame.size.height = CGFloat(slideView.value)
        self.innerColorView.center = CGPointMake(self.outerColorView.frame.size.width / 2, self.outerColorView.frame.size.height / 2);
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2

    }
    @IBAction func firstBrush(sender: AnyObject) {
        changeAndClose(0, g: 0, b: 0)
    }
    @IBAction func secondBrush(sender: AnyObject) {
        changeAndClose(130, g: 88, b: 72)
    }
    @IBAction func thirdBrush(sender: AnyObject) {
        changeAndClose(124, g: 91, b: 166)
    }
    @IBAction func fourthBrush(sender: AnyObject) {
        changeAndClose(75, g: 84, b: 143)
    }
    @IBAction func fifthBrush(sender: AnyObject) {
        changeAndClose(135, g: 190, b: 221)
    }
    @IBAction func sixthBrush(sender: AnyObject) {
        changeAndClose(63, g: 127, b: 92)
    }
    @IBAction func seventhBrush(sender: AnyObject) {
        changeAndClose(124, g: 197, b: 105)
    }
    @IBAction func eighthBrush(sender: AnyObject) {
        changeAndClose(254, g: 141, b: 187)
    }
    @IBAction func ninthBrush(sender: AnyObject) {
        changeAndClose(246, g: 211, b: 47)
    }
    @IBAction func tenthBrush(sender: AnyObject) {
        changeAndClose(236, g: 121, b: 77)
    }
    @IBAction func eleventhBrush(sender: AnyObject) {
        changeAndClose(249, g: 84, b: 98)
    }
    @IBAction func twelfthBrush(sender: AnyObject) {
        changeAndClose(255, g: 255, b: 254)
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BrushView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        textValue.text = String(Int(GSketch.brushWidth))
        slideView.value = Float(GSketch.brushWidth)
        
        
        
        innerColorView.backgroundColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        print(GSketch.brushWidth)
        //        innerColorView.frame.size.width = GSketch.brushWidth
        //        innerColorView.frame.size.height = GSketch.brushWidth
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2
    
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.brushResize(self.slideView);
        })

    }


}
