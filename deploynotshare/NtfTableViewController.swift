//
//  NtfTableViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 04/04/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit
var GlobalNotificationView:NtfTableViewController!;
var checkon = false;
import SwiftyJSON

class NtfTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var ntfTableView: UITableView!
    var ntfTitle: [String] = []
    var ntfDescription: [String] = []
    var ntfImage: [String] = []
    var ntfNoteId: [String] = []
    var ntfFolderId: [String] = []
    var ntfUserId: [String] = []
    var notesobj = Note()
    var notificationobj = Notification()
    var noteObjs:Int = 0;
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        //        dispatch_async(dispatch_get_main_queue(),{
        if(!checkon){
            self.getAllNotification()
        }else{
            checkon = false
        }
        //        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        checkon = true
        GlobalNotificationView = self;
      
        getAllNotification()
        // Do any additional setup after loading the view.
    }
    
    func getAllNotification(){
        self.ntfTitle = []
        self.ntfDescription = []
        self.ntfImage = []
        self.ntfNoteId = []
        self.ntfFolderId = []
        self.ntfUserId = []
        
        if(self.notesobj.isConnectedToNetwork())
        {
            self.notificationobj.getNotification{(json:JSON) -> () in
                if(json["value"] != "false"){
                self.noteObjs = json.count;
                
                for(var i = 0 ; i < json.count ; i++){
                    if(json[i]["userid"].stringValue != ""){
                    let name = json[i]["foldername"].stringValue;
                    if (name=="") {
                        self.ntfTitle.append(json[i]["notename"].stringValue)
                        self.ntfDescription.append("\(json[i]["username"].stringValue) has shared \(json[i]["notename"].stringValue) Note with you.")
                    }
                    else {
                        self.ntfTitle.append(json[i]["foldername"].stringValue)
                        self.ntfDescription.append("\(json[i]["username"].stringValue) has shared \(json[i]["foldername"].stringValue) Folder with you.")
                    }
                    self.ntfImage.append(json[i]["profilepic"].stringValue)
                    self.ntfNoteId.append(json[i]["note"].stringValue)
                    self.ntfFolderId.append(json[i]["folder"].stringValue)
                    self.ntfUserId.append(json[i]["userid"].stringValue)
                    }
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.ntfTableView.reloadData()
                })
                
                }else{
                    dispatch_async(dispatch_get_main_queue(),{
                    self.noteObjs = 0
                    self.ntfTableView.reloadData()
                    })
                }
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteObjs;
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ntfTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
       
        cell.ntfTitle.text = ntfTitle[indexPath.row]
        cell.ntfDescription.text = ntfDescription[indexPath.row]
        if(ntfImage[indexPath.row] != ""){
        cell.ntfImage.image = notesobj.getImage(ntfImage[indexPath.row])
        }
        cell.ntfNote.text = ntfNoteId[indexPath.row]
        cell.ntfFolder.text = ntfFolderId[indexPath.row]
        cell.ntfUserId.text = ntfUserId[indexPath.row]
        
        cell.ntfImage.contentMode = .ScaleAspectFill
        cell.ntfImage.layer.cornerRadius = cell.ntfImage.frame.size.width / 2 - 2
        cell.ntfImage.clipsToBounds = true
        
        return cell
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
