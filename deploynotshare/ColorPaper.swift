
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
        GDetailView.view.backgroundColor = UIColor(rgba: "#96ceee")
        onSelect()
    }
    @IBAction func secondBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#fae8ce")
        onSelect()
    }
    @IBAction func thirdBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#97e1cc")
        onSelect()
    }
    @IBAction func fourthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#fdff7f")
        onSelect()
    }
    @IBAction func fifthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#9fdb86")
        onSelect()
    }
    @IBAction func sixthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#be9ff6")
        onSelect()
    }
    @IBAction func seventhBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#b6e29e")
        onSelect()
    }
    @IBAction func eighthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#dca9aa")
        onSelect()
    }
    @IBAction func ninthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#f0a6ef")
        onSelect()
    }
    @IBAction func tenthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(rgba: "#ffffff")
        onSelect()
    }
    @IBAction func eleventhBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_bg_1.png")!)
        onSelect()
    }
    @IBAction func twelfthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_bg_2.png")!)
        onSelect()
    }
    @IBAction func thirteenthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_bg_3.png")!)
        onSelect()
    }
    @IBAction func fourteenthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_bg_4.png")!)
        onSelect()
    }
    @IBAction func fifteenthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_bg_5.png")!)
        onSelect()
    }
    @IBAction func sixteenthBackground(sender: AnyObject) {
        GDetailView.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_bg_6.png")!)
        onSelect()
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ColorPaper", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
    @IBAction func paperClick(sender: AnyObject) {
//        self.ColorView.hidden = true
        self.PaperView.hidden = false
        PaperButton.backgroundColor = UIColor(rgba: "#ff5a60")
        PaperButton.titleLabel?.textColor = UIColor.whiteColor()
        ColorButton.backgroundColor = UIColor.whiteColor()
        ColorButton.titleLabel?.textColor = UIColor(rgba: "#ff5a60")
    }

}
