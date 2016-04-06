//
//  SettingViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 14/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import SwiftyJSON

class SettingViewController: UITableViewController{
    let notesobj = Note()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.title);
        
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
            //print("FB LINK");
            //UIApplication.sharedApplication().openURL(NSURL(string : "http://www.wohlig.com")!);
        }
        if(indexPath.section == 2 && indexPath.row==1)
        {
            if(self.notesobj.isConnectedToNetwork()){
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                
                let GIDSignInStat = GIDSignIn()
                GIDSignInStat.signOut()
                
                
                config.logoutFlush{(json:JSON) -> () in }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewControllerWithIdentifier("LoginScreen") as! ViewController
                //self.slideMenuController()?.changeMainViewController(secondViewController, close: true)
                self.presentViewController(secondViewController as UIViewController, animated: true, completion: nil)
                //self.slideMenuController()?.view.removeFromSuperview()
                
                //print("FB LINK");
                //UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id310633997")!);
            }else{
                let alert = UIAlertController(title: "Alert", message: "No Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                    
                }
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true) { () -> Void in }
            }
        }
    }
}
