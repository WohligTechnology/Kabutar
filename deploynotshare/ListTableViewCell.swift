//
//  ListTableViewCell.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 26/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import SwiftyJSON
class ListTableViewCell: MGSwipeTableCell {
    
    @IBOutlet weak var ListViewTitle: UILabel!
    @IBOutlet weak var ListLock: UIImageView!
    @IBOutlet weak var DetailViewTitle: UILabel!
    @IBOutlet weak var DetailDescription: UILabel!
    @IBOutlet weak var DetailTimeStamp: UILabel!
    @IBOutlet weak var DetailLock: UIImageView!
    @IBOutlet weak var ntfTitle: UILabel!
    @IBOutlet weak var ntfDescription: UILabel!
    @IBOutlet weak var ntfImage: UIImageView!
    @IBOutlet weak var ntfNote: UILabel!
    @IBOutlet weak var ntfFolder: UILabel!
    @IBOutlet weak var ntfUserId: UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let appApplication = UIApplication.sharedApplication().delegate as! App
    var note = "";
    var folder = "";
    var userid = "";
    var ntfobj = Notification()
    var noteobj = Note()
    var folderobj = Folder()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showPopup (title:String, msgBody:String){
        let alertController = UIAlertController(title: title, message: msgBody, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
            print(action)
        }
        alertController.addAction(cancelAction)
        
        
        GlobalNotificationView.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func downNotification(val:Int64,json:JSON){
        if(json["value"]=="true"){
            if val == 1 {
                self.showPopup("Notification", msgBody: "Notification Rejected!")
            }else{
                self.showPopup("Notification", msgBody: "Notification Accepted!")

            }
            ntfobj.notificationCount{(json: JSON) -> () in
                UIApplication.sharedApplication().applicationIconBadgeNumber = Int(json["count"].stringValue)!
            }
            
            self.folderobj.localtoserver{(json: JSON) -> () in
                self.folderobj.servertolocal{(json: JSON) -> () in
                    self.noteobj.localtoserver{(json: JSON) -> () in
                        self.noteobj.servertolocal{(json: JSON) -> () in
                        }
                    }
                }
            }
            GlobalNotificationView.getAllNotification()
//            config.invokeAlertMethod("Notification",msgBody: "Notification Accepted",delegate: self)
            

        }
        
    }

    @IBAction func ntfCancel(sender: AnyObject) {
        ntfobj.notificationStatus(ntfNote.text!, folder: ntfFolder.text!, userid: ntfUserId.text!, status: "false", completion: {(json:JSON) in
            self.downNotification(1,json:json)
        })
    }
    
    @IBAction func ntfAccept(sender: AnyObject) {
        ntfobj.notificationStatus(ntfNote.text!, folder: ntfFolder.text!, userid: ntfUserId.text!, status: "true", completion: {(json:JSON) in
            self.downNotification(2,json:json)
        })
    }
}
