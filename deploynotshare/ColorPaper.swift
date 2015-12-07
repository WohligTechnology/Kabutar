
//  ColorPaper.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 10/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ColorPaper: UIView {

    
//    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var PaperView: UIView!
    @IBOutlet weak var ColorButton: UIButton!
    @IBOutlet weak var PaperButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib ()
    }
    
    func onSelect(){
        let patternpopup = ViewForNotes as! DetailViewFooterMain
        patternpopup.closeBackgroundTap(nil)
    }
    
    @IBAction func firstBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func secondBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func thirdBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func fourthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func fifthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func sixthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func seventhBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func eighthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func ninthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func tenthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func eleventhBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func twelfthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func thirteenthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func fourteenthBackground(sender: AnyObject) {
        onSelect()
    }
    @IBAction func fifteenthBackground(sender: AnyObject) {
        onSelect()
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ColorPaper", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
//        ColorButton.backgroundColor = UIColor(rgba: "#ff5a60")
//        ColorButton.backgroundColor = UIColor(rgba: "#ff5a60")
//        ColorButton.titleLabel?.textColor = UIColor(rgba: "#ffffff")
//        PaperButton.backgroundColor = UIColor(rgba: "#ffffff")
//        PaperButton.titleLabel?.textColor = UIColor(rgba: "#ff5a60")
    }
    
//    @IBAction func colorClick(sender: AnyObject) {
////        self.ColorView.hidden = false
//        self.PaperView.hidden = true
//        ColorButton.backgroundColor = UIColor(rgba: "#ff5a60")
//        ColorButton.titleLabel?.textColor = UIColor(rgba: "#ffffff")
//        PaperButton.backgroundColor = UIColor(rgba: "#ffffff")
//        PaperButton.titleLabel?.textColor = UIColor(rgba: "#ff5a60")
//        
//    }
    @IBAction func paperClick(sender: AnyObject) {
//        self.ColorView.hidden = true
        self.PaperView.hidden = false
        PaperButton.backgroundColor = UIColor(rgba: "#ff5a60")
        PaperButton.titleLabel?.textColor = UIColor.whiteColor()
        ColorButton.backgroundColor = UIColor.whiteColor()
        ColorButton.titleLabel?.textColor = UIColor(rgba: "#ff5a60")
    }

}
