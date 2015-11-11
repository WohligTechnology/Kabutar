//
//  MenuListViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 30/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import DKChainableAnimationKit

var slideMenuLeft:Any!;

protocol LeftMenuProtocol : class {
    func changeViewController(menu: Int)
}

class MenuListViewController: UITableViewController, LeftMenuProtocol {
    
    var mainViewController: UIViewController!
    
    var folderViewController: UIViewController!
    var detailview:UIViewController!
    var noteViewController: UIViewController!
    var FeedbackView: UIViewController!
    
    @IBOutlet var menuStaticTable: UITableView!
    @IBOutlet weak var profileimage: UIImageView!
    
    var menuName = ["demo","Notes","Folders","About NoteShare","Terms & Conditions","Notification Center","Rate Us","Like us on Facebook","Send Feedback","Invite Friends","Setting","Logout"]
    var menuImage = ["demo","note_menu_icon","folder_icon","about_us_icon","termsandcondition_icon","notification_icon","rate_us_icon","likeus_on_icon","send_feedback_icon","invite_icon","setting_icon","logout_icon"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuStaticTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteViewController = storyboard.instantiateViewControllerWithIdentifier("cardViewController") as! cardViewController
        self.noteViewController = UINavigationController(rootViewController: noteViewController)
        
        let folderViewController = storyboard.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
        self.folderViewController = UINavigationController(rootViewController: folderViewController)
        
        let detailview = storyboard.instantiateViewControllerWithIdentifier("Detailview") as! Detailview
        self.detailview = UINavigationController(rootViewController: detailview)
        
        let FeedbackView = storyboard.instantiateViewControllerWithIdentifier("ThinkViewController") as! ThinkViewController
        self.FeedbackView = UINavigationController(rootViewController: FeedbackView)
        
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
        }else {
            if(indexPath.row == 3)
            {
                let singleline = UIView(frame: CGRectMake(0, 0, cell.frame.width, 1));
                singleline.backgroundColor = PinkColor
                cell.addSubview(singleline);
            }
            
            cell.textLabel!.text = menuName[indexPath.row]
            cell.separatorInset.left = 60
            cell.imageView?.sizeThatFits(CGSize(width: 26, height: 26))
            cell.imageView?.image = UIImage(named: menuImage[indexPath.row])
            
        }
        return cell
   }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedFolderToNoteId = ""
        if(indexPath.row == 1){
            self.slideMenuController()?.changeMainViewController(self.noteViewController, close: true)
            
        
        }
        if(indexPath.row == 2){
            changeViewController(2)
            
            
        }
        if(indexPath.row == 3){
            self.slideMenuController()?.changeMainViewController(self.detailview, close: true)
            
            
        }
        if(indexPath.row == 7){
            changeViewController(7)
        }
    }
    
    
    func changeViewController(menu: Int) {
        if(menu == 1){
             self.slideMenuController()?.changeMainViewController(self.noteViewController, close: true)
            
            
        }
        if(menu  == 2){
            self.slideMenuController()?.changeMainViewController(self.folderViewController, close: true)
            
            
        }
        if(menu == 3){
            self.slideMenuController()?.changeMainViewController(self.detailview, close: true)
            
            
        }
        if(menu == 7){
            self.slideMenuController()?.changeMainViewController(self.FeedbackView, close: true)
        }
    }

    
    
    func ChangeMyView () -> SlideMenuController? {
        return self.slideMenuController()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuName.count
    }
}
