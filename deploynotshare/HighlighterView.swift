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
    
    @IBAction func firstColor(sender: AnyObject) {
    }
    @IBAction func secondClick(sender: AnyObject) {
        GSketch.changeColor(0.0, blue2: 4.0, green2: 7.0)
        self.removeFromSuperview()
        
    }
    @IBAction func thirdClick(sender: AnyObject) {
    }
    @IBAction func fourthClick(sender: AnyObject) {
    }
    @IBAction func fifthClick(sender: AnyObject) {
    }
    @IBAction func sixthclick(sender: AnyObject) {
    }
    @IBAction func seventhClick(sender: AnyObject) {
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
        textValue.text = "15"
        highlight = self
        
    }
    
    

}
