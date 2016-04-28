//
//  DetailViewFooterMain.swift
//  deploynotshare
//
//  Created by Chintan Shah on 09/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

var newInsideNoteMenu:InsideNoteMenu!
var newColorPaper:ColorPaper!

import UIKit

class DetailViewFooterMain: UIView {
    @IBAction func deleteSectionTap(sender: AnyObject) {
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.deleteTap();
    }
    
    @IBAction func addTextTap(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addTextTap(true);
    }
    
    @IBAction func addImageTap(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addImageTap();
    }
    
  
    @IBAction func addSketchTap(sender: AnyObject) {
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addSketchTap();
    }
   
    @IBAction func addAudioTap(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addAudioTap(true);
    }
    
    @IBAction func addCheckBox(sender: AnyObject) {
        NoteElementModel.addHeightOffset(GvLayout)
        let DetailViewCtrl = GDetailView
        DetailViewCtrl.addCheckBox(true);
    }
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.window?.frame.width)!, (self.window?.frame.height)!))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    @IBAction func setBackground(sender: AnyObject) {
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeBackgroundTap:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        newColorPaper = ColorPaper(frame: CGRectMake((width)-340, (height)-40, 300,200));
        
        self.window?.addSubview(newColorPaper)
        newColorPaper.animation.moveY(-350).easeInOut.animate(transitionTime)
    }
    @IBAction func addMenu(sender: AnyObject) {
        print(selectedNoteId)
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeMenuTap:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        newInsideNoteMenu = InsideNoteMenu(frame: CGRectMake(40, (self.window?.frame.height)!+75, (self.window?.frame.width)! - 80,200));
        newInsideNoteMenu.layer.zPosition = 100000
        self.window?.addSubview(newInsideNoteMenu)
        newInsideNoteMenu.animation.moveY(-350).easeInOut.animate(transitionTime)

    }
    
    func closeMenuTap (sender:UITapGestureRecognizer?) {
        newInsideNoteMenu.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            newInsideNoteMenu.removeFromSuperview()
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
    }
    
    
    func closeBackgroundTap (sender:UITapGestureRecognizer?) {
        newColorPaper.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            newColorPaper.removeFromSuperview()
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
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
        let nib = UINib(nibName: "DetailViewFooterMain", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }


}
