//
//  ElementSketchFooter.swift
//  deploynotshare
//
//  Created by Chintan Shah on 11/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//
var highlightView:HighlighterView!
var brushView: BrushView!
var eraserView: EraserView!

import UIKit

class ElementSketchFooter: UIView {
    
    
    @IBAction func colorChange(sender: AnyObject) {
        GSketch.changeColor(0, blue2: 1, green2: 0)
    }
    @IBAction func brushChange(sender: AnyObject) {
        //Highlight and black out popup
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeBrush:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        brushView = BrushView(frame: CGRectMake(35, (self.window?.frame.height)!-235, (self.window?.frame.width)!-60,172));
        
        self.window?.addSubview(brushView)
        brushView.animation.moveY(-172).easeInOut.animate(transitionTime)
        
        GSketch.changeColor(0.0,blue2: 0.0,green2: 0.0)
        GSketch.changeOpacity(1.0)
    }
    
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.window?.frame.width)!, (self.window?.frame.height)!))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func closeHighlight (sender:UITapGestureRecognizer?) {
        
        highlightView.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            highlightView.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
        
    }
    
    
    func closeBrush (sender:UITapGestureRecognizer?) {
        
        brushView.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            brushView.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
        
    }
    
    
    func closeEraser (sender:UITapGestureRecognizer?) {
        
        eraserView.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            eraserView.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
        
    }
    
    @IBAction func highlightChange(sender: AnyObject) {
        //Highlight and black out popup
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeHighlight:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        highlightView = HighlighterView(frame: CGRectMake(35, (self.window?.frame.height)!-235, (self.window?.frame.width)!-60,172));
        
        self.window?.addSubview(highlightView)
        highlightView.animation.moveY(-172).easeInOut.animate(transitionTime)
        
    }
    @IBAction func eraserChange(sender: AnyObject) {
        //Highlight and black out popup
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeEraser:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        eraserView = EraserView(frame: CGRectMake(35, (self.window?.frame.height)!-235, (self.window?.frame.width)!-60,172));
        
        self.window?.addSubview(eraserView)
        eraserView.animation.moveY(-172).easeInOut.animate(transitionTime)
        
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
//        GDetailView = self
    }
}