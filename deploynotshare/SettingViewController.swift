//
//  SettingViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 14/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        print(indexPath.section);
        if(indexPath.section == 1){
            let passcodemodal = self.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
            passcodemodal.lockValue = 4
            self.presentViewController(passcodemodal, animated: true, completion: nil)
        }
        if(indexPath.section == 2 && indexPath.row==0)
        {
            print("FB LINK");
            UIApplication.sharedApplication().openURL(NSURL(string : "http://www.wohlig.com")!);
        }
        if(indexPath.section == 2 && indexPath.row==1)
        {
            print("FB LINK");
            UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id310633997")!);
        }
    }
    
    
}
