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
    @IBOutlet weak var sizeView: UIButton!
    var centerx:CGFloat!
    var centery:CGFloat!
    var allSubview: ElementSketchFooter!
    
    func changeAndClose(r:CGFloat, b:CGFloat, g:CGFloat){
        GSketch.changeColor(r/255, blue2: b/255, green2: g/255)
        blackOut.removeFromSuperview()
        highlightView.removeFromSuperview()
        
    }
    
    @IBOutlet weak var sliderView: UISlider!
    @IBAction func firstColor(sender: AnyObject) {
        changeAndClose(255, b: 30, g: 91)
    }
    @IBAction func secondClick(sender: AnyObject) {
        changeAndClose(224, b: 78, g: 247)
    }
    @IBAction func thirdClick(sender: AnyObject) {
        changeAndClose(106, b: 157, g: 70)
    }
    @IBAction func fourthClick(sender: AnyObject) {
        changeAndClose(58, b: 240, g: 168)
    }
    @IBAction func fifthClick(sender: AnyObject) {
        changeAndClose(255, b: 148, g: 75)
    }
    @IBAction func sixthclick(sender: AnyObject) {
        changeAndClose(55, b: 125, g: 206)
    }
    @IBAction func seventhClick(sender: AnyObject) {
        changeAndClose(188, b: 188, g: 188)
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
        print(self.sizeView.frame.size.width)
        print(sender.value)
        self.sizeView.frame.size.width = CGFloat(sliderValue.value)
        self.sizeView.frame.size.height = CGFloat(sliderValue.value)
        GSketch.brushWidth = CGFloat(sliderValue.value)

        textValue.text = String(Int(sliderValue.value))
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "HighlighterView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        centerx  = self.center.x
        centery = self.center.y
        color1.backgroundColor = UIColor.redColor()
        sizeView.backgroundColor = UIColor.blackColor()
        textValue.text = String(Int(GSketch.brushWidth))
        highlight = self
        sliderView.value = Float(GSketch.brushWidth)
        
    }
    
    

}
