//
//  MenuListViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 30/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import DKChainableAnimationKit
import FBSDKCoreKit
import FBSDKLoginKit
import Google

var isInsideFolder = 0
var slideMenuLeft:SlideMenuController!;

protocol LeftMenuProtocol : class {
    func changeViewController(menu: Int)
}

class MenuListViewController: UITableViewController, LeftMenuProtocol {
    
    
    
    var mainViewController: UIViewController!
    
    var folderViewController: UIViewController!
    var detailview:UIViewController!
    var listView: UIViewController!
    var noteViewController: UIViewController!
    var profilePic: UIViewController!
    var AboutView: UIViewController!
    var SettingView: UIViewController!
    
    @IBOutlet var menuStaticTable: UITableView!
    @IBOutlet weak var profileimage: UIImageView!
    
    var menuName = ["demo","Notes","Folders","Notification Center","Rate Us","Like us on Facebook","Send Feedback","Invite Friends","Settings"]
    var menuImage = ["demo","menu_note","menu_folder","menu_notification","menu_invite","menu_setting","menu_about","menu_logout","menu_logout"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuStaticTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let profilePic = storyboard.instantiateViewControllerWithIdentifier("SelectProfile") as! ProfilePic
        self.profilePic = UINavigationController(rootViewController: profilePic)
        
        let noteViewController = storyboard.instantiateViewControllerWithIdentifier("cardViewController") as! cardViewController
        self.noteViewController = UINavigationController(rootViewController: noteViewController)
        
        let listView = storyboard.instantiateViewControllerWithIdentifier("Listview") as! Listview
        self.listView = UINavigationController(rootViewController: listView)
        
        let folderViewController = storyboard.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
        self.folderViewController = UINavigationController(rootViewController: folderViewController)
        
        let detailview = storyboard.instantiateViewControllerWithIdentifier("Detailview") as! Detailview
        self.detailview = UINavigationController(rootViewController: detailview)
                
        let AboutView = storyboard.instantiateViewControllerWithIdentifier("AboutTableViewController") as! AboutTableViewController
        self.AboutView = UINavigationController(rootViewController: AboutView)
        
        let SettingView = storyboard.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        self.SettingView = UINavigationController(rootViewController: SettingView)
        
        slideMenuLeft = self.slideMenuController()
        
        
        
        //        self.profileimage!.layer.cornerRadius = self.profileimage.frame.size.width / 5
        //        self.profileimage.clipsToBounds = true
        //        self.profileimage.layer.borderWidth = 2.0
        //        self.profileimage.layer.borderColor = UIColor.whiteColor().CGColor
        
        menuStaticTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if(indexPath.row == 0)
        {
            let bounds = UIScreen.mainScreen().bounds
            let width = bounds.size.width
            //            let height = bounds.size.height
            
            let insideView = NavigationTableCell(frame: CGRectMake(0,0,width,100))
            
            insideView.cellImage!.layer.cornerRadius = insideView.cellImage.frame.size.width / 2 - 2
            insideView.cellImage.clipsToBounds = true
            insideView.cellImage.layer.borderWidth = 2.0
            insideView.cellImage.layer.borderColor = UIColor.whiteColor().CGColor
            
            cell.addSubview(insideView);
        }
            else {
            
            if(indexPath.row == 3)
            {
                let singleline = UIView(frame: CGRectMake(0, 0, cell.frame.width, 1));
                singleline.backgroundColor = PinkColor
                cell.addSubview(singleline);
            }
            cell.textLabel?.font = UIFont(name: "Agenda", size: 16)
            cell.textLabel!.text = menuName[indexPath.row]
            cell.textLabel?.textColor = UIColor(rgba: "#636363");
            cell.separatorInset.left = 60
            
            let imageview = UIImageView(frame: CGRectMake(15,10,24,24))
            imageview.image = UIImage(named: menuImage[indexPath.row])
            
            imageview.contentMode = UIViewContentMode.ScaleAspectFit
            imageview.image = imageview.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            imageview.tintColor = UIColor(rgba: "#636363")
            cell.addSubview(imageview)
            
            //cell.imageView?.sizeThatFits(CGSize(width: 10, height: 10))
            //cell.imageView?.image = UIImage(named: menuImage[indexPath.row])
            //cell.imageView?.tintColor = UIColor(rgba: "#636363");
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedFolderToNoteId = ""
        
        switch(indexPath.row)
        {
            
        case 0:
            isInsideFolder = 0
            self.slideMenuController()?.changeMainViewController(self.profilePic, close: true)
            
            
        case 1:
            isInsideFolder = 0
            let noteView = config.get("note_view")
            switch noteView
            {
            case "1":
                self.slideMenuController()?.changeMainViewController(self.detailview, close: true)
            case "2":
                self.slideMenuController()?.changeMainViewController(self.listView, close: true)
            case "3":
                self.slideMenuController()?.changeMainViewController(self.noteViewController, close: true)
            default:
                self.slideMenuController()?.changeMainViewController(self.detailview, close: true)
                
            }
        case 2:
            isInsideFolder = 1
            self.slideMenuController()?.changeMainViewController(self.folderViewController, close: true)
        case 3:
            print("Noti");
            //UIApplication.sharedApplication().openURL(NSURL(string : "http://www.wohlig.com")!);
            //task.resume()
        case 4:
            let textToShare = "Swift is awesome!  Check out this website about it!"
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
            print("Invite");
        case 5:
            self.slideMenuController()?.changeMainViewController(self.SettingView, close: true)
        case 6:
            self.slideMenuController()?.changeMainViewController(self.AboutView, close: true)
        case 7:
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            
            let GIDSignInStat = GIDSignIn()
            GIDSignInStat.signOut()

            
            config.logoutFlush()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewControllerWithIdentifier("LoginScreen") as! ViewController
            //self.slideMenuController()?.changeMainViewController(secondViewController, close: true)
            self.presentViewController(secondViewController as UIViewController, animated: true, completion: nil)
            //self.slideMenuController()?.view.removeFromSuperview()
        default:
            print("Default")
        }
        
    }
    
    
    func changeViewController(menu: Int) {
        if(menu == 1){
            isInsideFolder = 0
            self.slideMenuController()?.changeMainViewController(self.noteViewController, close: true)
        }
        if(menu  == 2){
            isInsideFolder = 1
            self.slideMenuController()?.changeMainViewController(self.folderViewController, close: true)
        }
        if(menu == 3){
            self.slideMenuController()?.changeMainViewController(self.detailview, close: true)
        }
    }
    
    
    
    func ChangeMyView () -> SlideMenuController? {
        return self.slideMenuController()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuName.count
    }
}
