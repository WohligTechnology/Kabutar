//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        let font = UIFont(name: "Agenda-Bold", size: 18)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font!, NSForegroundColorAttributeName : UIColor.whiteColor() ]
        self.navigationController?.navigationBar.translucent = false
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.navigationController?.toolbar.barTintColor = PinkColor
        self.navigationController?.navigationBar.barTintColor = PinkColor
        
        self.navigationController?.navigationBar.topItem!.title = self.title?.uppercaseString
        
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
}