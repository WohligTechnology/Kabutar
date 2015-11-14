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
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func changeAndClose(r:CGFloat, b:CGFloat, g:CGFloat){
        GSketch.changeColor(r/255, blue2: b/255, green2: g/255)
//        GSketch.changeOpacity(0.4)
//        blackOut.removeFromSuperview()
//        brushView.removeFromSuperview()
        
    }
    
    @IBAction func brushResize(sender: UISlider) {
        GSketch.brushWidth = CGFloat(slideView.value)
        textValue.text = String(Int(slideView.value))
    }
    @IBAction func firstBrush(sender: AnyObject) {
        changeAndClose(255, b: 30, g: 91)
    }
    @IBAction func secondBrush(sender: AnyObject) {
        changeAndClose(224, b: 78, g: 247)
    }
    @IBAction func thirdBrush(sender: AnyObject) {
        changeAndClose(106, b: 157, g: 70)
    }
    @IBAction func fourthBrush(sender: AnyObject) {
        changeAndClose(58, b: 240, g: 168)
    }
    @IBAction func fifthBrush(sender: AnyObject) {
        changeAndClose(255, b: 148, g: 75)
    }
    @IBAction func sixthBrush(sender: AnyObject) {
        changeAndClose(55, b: 125, g: 206)
    }
    @IBAction func seventhBrush(sender: AnyObject) {
        changeAndClose(188, b: 188, g: 188)
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BrushView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        textValue.text = String(Int(GSketch.brushWidth))
//        highlight = self
        slideView.value = Float(GSketch.brushWidth)
    }


}
