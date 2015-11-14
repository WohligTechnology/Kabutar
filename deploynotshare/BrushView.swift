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
        innerViewSize = CGFloat(slideView.value)
        innerColorView.frame.size.width = CGFloat(slideView.value)
        innerColorView.frame.size.height = CGFloat(slideView.value)
        self.innerColorView.center = CGPointMake(self.outerColorView.frame.size.width / 2, self.outerColorView.frame.size.height / 2);
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2

    }
    @IBAction func firstBrush(sender: AnyObject) {
        changeAndClose(255, g: 91, b: 30)
    }
    @IBAction func secondBrush(sender: AnyObject) {
        changeAndClose(224, g: 247, b: 78)
    }
    @IBAction func thirdBrush(sender: AnyObject) {
        changeAndClose(106, g: 70, b: 157)
    }
    @IBAction func fourthBrush(sender: AnyObject) {
        changeAndClose(58, g: 168, b: 240)
    }
    @IBAction func fifthBrush(sender: AnyObject) {
        changeAndClose(255, g: 75, b: 148)
    }
    @IBAction func sixthBrush(sender: AnyObject) {
        changeAndClose(55, g: 206, b: 125)
    }
    @IBAction func seventhBrush(sender: AnyObject) {
        changeAndClose(188, g: 188, b: 188)
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
        innerColorView.frame.size.width = GSketch.brushWidth
        innerColorView.frame.size.height = GSketch.brushWidth
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2
    }


}
