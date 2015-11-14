//
//  ViewView.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ViewView: UIView {
    
    
    var mainViewController: UIViewController!
    
    var folderViewController: UIViewController!
    var detailview:UIViewController!
    var listview:UIViewController!
    var noteViewController: UIViewController!
    
    var newNoteFooter: NoteFooterAdd!
    


       
    @IBOutlet weak var detailclick: UIButton!
    @IBOutlet weak var viewpopup: UIView!
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteViewController = storyboard.instantiateViewControllerWithIdentifier("cardViewController") as! cardViewController
        self.noteViewController = UINavigationController(rootViewController: noteViewController)
        
        let folderViewController = storyboard.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
        self.folderViewController = UINavigationController(rootViewController: folderViewController)
        
        let detailview = storyboard.instantiateViewControllerWithIdentifier("Detailview") as! Detailview
        self.detailview = UINavigationController(rootViewController: detailview)
        
        let listview = storyboard.instantiateViewControllerWithIdentifier("Listview") as! Listview
        self.listview = UINavigationController(rootViewController: listview)


        
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

    @IBAction func detailClick(sender: AnyObject) {
        config.set("note_view",value2: "1")

        let abc = slideMenuLeft as! SlideMenuController
        abc.changeMainViewController(detailview, close: true)
        
        newViewView.removeFromSuperview()
        blackOut.removeFromSuperview()
    }
    
    @IBAction func listClick(sender: AnyObject) {
        config.set("note_view",value2: "2")

        let abc = slideMenuLeft as! SlideMenuController
        abc.changeMainViewController(listview, close: true)
        
        newViewView.removeFromSuperview()
        blackOut.removeFromSuperview()
    }
    
    @IBAction func tilesClick(sender: AnyObject) {
        config.set("note_view",value2: "3")

        let abc = slideMenuLeft as! SlideMenuController
        abc.changeMainViewController(noteViewController, close: true)
        
        newViewView.removeFromSuperview()
        blackOut.removeFromSuperview()
    }
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
