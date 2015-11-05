//
//  MenuListViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 30/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class MenuListViewController: UITableViewController {

    var mainViewController: UIViewController!
    
    @IBOutlet var menuStaticTable: UITableView!
    @IBOutlet weak var profileimage: UIImageView!
    
    var menuName = ["Notes","Folders","About NoteShare","Terms & Conditions","Notification Center","Rate Us","Like us on Facebook","Send Feedback","Invite Friends","Setting","Logout"]
    var menuImage = ["note_menu_icon","folder_icon","about_us_icon","termsandcondition_icon","notification_icon","rate_us_icon","likeus_on_icon","send_feedback_icon","invite_icon","setting_icon","logout_icon"]
    override func viewDidLoad() {
        super.viewDidLoad()
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
            cell.
        }
        else {
        cell.textLabel!.text = menuName[indexPath.row]
        cell.imageView?.image = UIImage(named: menuImage[indexPath.row])
        }
        return cell
   }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuName.count+1
    }
}
