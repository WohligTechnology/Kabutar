//
//  HighlighterView.swift
//  NoteShare
//
//  Created by Tushar Sachde on 12/11/15.
//  Copyright © 2015 Tushar Sachde. All rights reserved.
//
import UIKit
var highlight: UIView!

class HighlighterView: UIView {
    
    @IBOutlet weak var color1: UIButton!
    var centerx:CGFloat!
    var centery:CGFloat!
    var allSubview: ElementSketchFooter!
    
    @IBOutlet weak var outerColorView: UIView!
    @IBOutlet weak var innerColorView: UIView!
    @IBOutlet weak var slideView: UISlider!
    func changeAndClose(r:CGFloat, g:CGFloat, b:CGFloat){
        red = r;
        green = g;
        blue = b;
        GSketch.changeColor(r/255, green2: g/255, blue2: b/255)
        innerColorView.backgroundColor = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
        
    }
    
    @IBOutlet weak var sliderView: UISlider!
    @IBAction func firstColor(sender: AnyObject) {
        changeAndClose(255, g: 91, b: 30)
    }
    @IBAction func secondClick(sender: AnyObject) {
        changeAndClose(224, g: 247, b: 78)
    }
    @IBAction func thirdClick(sender: AnyObject) {
        changeAndClose(106, g: 70, b: 157)
    }
    @IBAction func fourthClick(sender: AnyObject) {
        changeAndClose(58, g: 168, b: 240)
    }
    @IBAction func fifthClick(sender: AnyObject) {
        changeAndClose(255, g: 75, b: 148)
    }
    @IBAction func sixthclick(sender: AnyObject) {
        changeAndClose(55, g: 206, b: 125)
    }
    @IBAction func seventhClick(sender: AnyObject) {
        changeAndClose(188, g: 188, b: 188)
    }
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var textValue: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func setWidth(width: CGFloat) {
        var frame: CGRect = self.frame
        
        
        frame.size.width = width
        self.frame = frame
        self.center = CGPoint(x: self.centerx, y: self.centery)
    }
    
    @IBAction func resizer(sender: UISlider) {
        GSketch.brushWidth = CGFloat(slideView.value)
        textValue.text = String(Int(slideView.value))
        innerViewSize = CGFloat(slideView.value)
        innerColorView.alpha = 1.0;
        innerColorView.frame.size.width = CGFloat(slideView.value)
        innerColorView.frame.size.height = CGFloat(slideView.value)
        self.innerColorView.center = CGPointMake(self.outerColorView.frame.size.width / 2, self.outerColorView.frame.size.height / 2);
        innerColorView.layer.cornerRadius = self.innerColorView.frame.size.width / 2
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "HighlighterView", bundle: bundle)
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
            
            self.resizer(self.slideView);
            
        })

        
    }
    
    

}
