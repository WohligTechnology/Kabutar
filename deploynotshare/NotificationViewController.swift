//
//  NotificationViewController.swift
//  deploynotshare
//
//  Created by Chintan Shah on 09/03/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationViewController: UIViewController {
    var notesobj = Note()
    var image = ["demo","Notes"]
    var notiTitle = ["demo","note_black"]
    var notiDescription = ["kdjshfjh","demo description"]
    var verticalLayout : VerticalLayout!
    var notificationobj = Notification()
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    func showNotification(json: JSON){
        
        if(json == 1)
        {
            print("ERROR IS FUCKING ASS HOLE");
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),{
                print(json[0])
                for(var i=0;i<json.count;i++){
                    let notification = NotificationView(frame: CGRectMake(0,0,width,100));
                    self.verticalLayout.addSubview(notification);
                    notification.notifTitle.text = json[i]["notename"].string;
                    notification.notifDescription.text = json[i]["username"].string;
                }
            });
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        self.verticalLayout = VerticalLayout(width: self.view.frame.width);
        self.scrollView.insertSubview(self.verticalLayout, atIndex: 0)
    
        
        notificationobj.getNotification(showNotification);
        print("notification in controller");
        


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
