//
//  ViewView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ViewView: UIView {

    var slideMenu: SlideMenuController! = SlideMenuController()
    
    @IBOutlet weak var detailclick: UIButton!
    @IBOutlet weak var viewpopup: UIView!
     var detailview:UIViewController!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let detailview = storyboard.instantiateViewControllerWithIdentifier("Detailview") as! Detailview
        self.detailview = UINavigationController(rootViewController: detailview)
        loadViewFromNib ()
        //        NSBundle.mainBundle().loadNibNamed("SortView", owner: self, options: nil)
        //        self.addSubview(self.sortnewview)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ViewView", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        sortnewview.frame = bounds
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
        
    }

//    @IBAction func detailClick(sender: AnyObject) {
//        print("TESTING");
//        let menu = MenuListViewController();
//    
//        let slidemenu = menu.ChangeMyView()
//        
//        slidemenu!.changeMainViewController(self.detailview, close: true)
//        
//    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
