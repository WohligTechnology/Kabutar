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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downNotification(json:JSON){
        if(json["value"]=="true"){
            ntfobj.notificationCount{(json: JSON) -> () in
                UIApplication.sharedApplication().applicationIconBadgeNumber = Int(json["count"].stringValue)!
            }
            
            self.noteobj.localtoserver{(json: JSON) -> () in
                self.noteobj.servertolocal{(json: JSON) -> () in
                }
            }
            GlobalNotificationView.getAllNotification()
        }
    }

    @IBAction func ntfCancel(sender: AnyObject) {
        ntfobj.notificationStatus(ntfNote.text!, folder: ntfFolder.text!, userid: ntfUserId.text!, status: "false", completion: downNotification)
    }
    
    @IBAction func ntfAccept(sender: AnyObject) {
        ntfobj.notificationStatus(ntfNote.text!, folder: ntfFolder.text!, userid: ntfUserId.text!, status: "true", completion: downNotification)
    }
}
