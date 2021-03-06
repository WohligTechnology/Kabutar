
//  NotificationViewController.swift
//  deploynotshare
//
//  Created by Chintan Shah on 09/03/16.
//  Copyright © 2016 Wohlig. All rights reserved.

import UIKit
import SwiftyJSON
//var GlobalNotificationView:NotificationViewController!;
//var checkon = false;
class NotificationViewController: UIViewController {
    var notesobj = Note()
    var image = ["demo","Notes"]
    var notiTitle = ["demo","note_black"]
    var notiDescription = ["kdjshfjh","demo description"]
    var verticalLayout : VerticalLayout!
    var notificationobj = Notification()
    var selectedNoti : JSON!;
//    var checkon = false

    @IBOutlet weak var scrollView: UIScrollView!
    
    func showNotification(json: JSON){
        
        if(json == 1)
        {
            print("ERROR.");
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),{
                if(json["value"] != "false"){
                for(var i=0;i<json.count;i++){
                    let notification = NotificationView(frame: CGRectMake(0,0,width,100));
                    self.verticalLayout.addSubview(notification);
                    let name = json[i]["foldername"].stringValue;
                    if (name=="") {
                        notification.notifTitle.text = json[i]["notename"].stringValue;
                        notification.notifDescription.text = "\(json[i]["username"].stringValue) has shared \(json[i]["notename"].stringValue) Note with you.";
                    }
                    else {
                        notification.notifTitle.text = json[i]["foldername"].stringValue;
                        notification.notifDescription.text = "\(json[i]["username"].stringValue) has shared \(json[i]["foldername"].stringValue) Folder with you.";
                    }
                    let note = Note();
                    notification.notifimage.image = note.getImage(json[i]["profilepic"].stringValue);
                    
//                    notification.notifimage.layer.borderWidth = 5.0
//                    notification.notifimage.layer.borderColor = UIColor.whiteColor().CGColor
                    notification.note = json[i]["note"].stringValue
                    notification.folder = json[i]["folder"].stringValue
                    notification.userid = json[i]["userid"].stringValue
                    }
                }
            });
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
//        dispatch_async(dispatch_get_main_queue(),{
        if(!checkon){
            print("in side reload calling")
            self.reload();
        }else{
            checkon = false
            }
//        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        GlobalNotificationView = self;

        print("view did load.")
        checkon = true
        self.setNavigationBarItem()
//        notesobj.localtoserver{(json: JSON) -> () in }

//        dispatch_async(dispatch_get_main_queue(),{

        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        self.verticalLayout = VerticalLayout(width: self.view.frame.width);
        self.scrollView.insertSubview(self.verticalLayout, atIndex: 0)
            if(self.notesobj.isConnectedToNetwork())
            {
                self.notificationobj.getNotification(self.showNotification);
            }
//            self.resizeView()
//        });
        
        
    }
    
    func reload() {
        dispatch_async(dispatch_get_main_queue(),{
            self.verticalLayout.removeFromSuperview()
            self.verticalLayout = VerticalLayout(width: self.view.frame.width);
            self.scrollView.insertSubview(self.verticalLayout, atIndex: 0)
            if(self.notesobj.isConnectedToNetwork())
            {
            self.notificationobj.getNotification(self.showNotification);
            }
        });

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func getNotification () {
        // api data goes here.
        
        
    }
    func resizeView(offset:CGFloat)
    {
        self.verticalLayout.layoutSubviews()
        self.scrollView.contentSize = CGSize(width: self.verticalLayout.frame.width, height: self.verticalLayout.frame.height + offset)
    }
}
