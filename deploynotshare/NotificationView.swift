//
//  NotificationView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit
import SwiftyJSON

@IBDesignable class NotificationView: UIView {
    
    @IBOutlet weak var notifTitle: UILabel!
    @IBOutlet weak var notifDescription: UILabel!
    @IBOutlet weak var notifimage: UIImageView!
    @IBOutlet weak var notifDown: UIButton!
    @IBOutlet weak var notifCancel: UIButton!
    var notificationobj = Notification()
    
    var note = "";
    var folder = "";
    var userid = "";
    var status = "";
    var noteobj = Note()
    
    func downNotification(json:JSON){
        if(json["value"]=="true"){
            self.noteobj.localtoserver{(json: JSON) -> () in
                self.noteobj.servertolocal{(json: JSON) -> () in
                }
            }
//            GlobalNotificationView.reload()
        }
    }
    
    @IBAction func cancelTap(sender: AnyObject) {
        
        notificationobj.notificationStatus(note, folder: folder, userid: userid, status: "false", completion: downNotification)
    }
    
    @IBAction func acceptTap(sender: AnyObject) {
        notificationobj.notificationStatus(note, folder: folder, userid: userid, status: "true", completion: downNotification)
    }
    
    
    
    @IBOutlet var notificationview: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
        
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NotificationView", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        sortnewview.frame = bounds
        
//        self.notifimage.contentMode = .Center
        self.notifimage.layer.cornerRadius = 100 / 2
//                            badge.layer.masksToBounds = true
        self.notifimage.layer.masksToBounds = true
        
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
    }
}