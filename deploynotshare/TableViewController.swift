//
//  TableViewController.swift
//  NoteShare
//
//  Created by Tushar Sachde on 21/10/15.
//  Copyright © 2015 Tushar Sachde. All rights reserved.
//

import UIKit
import SwiftyJSON
var selectedFolderToNoteId: String = ""

var globalFolderId: Any!
var FolderViewController : TableViewController!
var last_navigation:UINavigationController!
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let mainColor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    let hoverColor = UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    var folderName:NSMutableArray = []
    var folderId:NSMutableArray = []
    var folderServerId:NSMutableArray = []
    var filteredNotes = [String]()
    var resultSearchController = UISearchController!()
    var createfolsername = UITextField()
    var folderobj = Folder()
    var emaillist = UITextField()
    var notesobj = Note()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        
        FolderViewController = self;
//        self.folderobj.localtoserver{(json:JSON) -> () in
//            self.folderobj.servertolocal{(json:JSON) -> () in
        
                self.folderName = []
                self.folderId = []
                self.folderServerId = []
                let a = Folder();
                for row in a.find() {
                    self.folderName.addObject(row[a.name]!)
                    self.folderId.addObject(String(row[a.id]))
                    self.folderServerId.addObject(String(row[a.serverID]))
                }
                //a.servertolocal()
                
                self.resultSearchController = UISearchController(searchResultsController: nil)
                self.resultSearchController.searchResultsUpdater = self
                self.resultSearchController.dimsBackgroundDuringPresentation = false
                self.resultSearchController.searchBar.sizeToFit()
                
                self.resultSearchController.searchBar.barTintColor = PinkColor
                self.resultSearchController.searchBar.translucent = false
                
                self.resultSearchController.searchBar.tintColor = UIColor.whiteColor()
                
                self.definesPresentationContext = true
                
                self.tableView.tableHeaderView = self.resultSearchController.searchBar
                self.tableView.reloadData()
                
                //Clear Empty Cells
                let backgroundView = UIView(frame: CGRectZero)
                self.tableView.tableFooterView = backgroundView
                self.tableView.backgroundColor = UIColor.clearColor()
                
                //Show search on scroll
                self.tableView.setContentOffset(CGPoint(x: 0,y: 44), animated: true)
                self.title = "Folders"
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.resultSearchController.active)
        {
            return self.filteredNotes.count
        }
        else
        {
            return self.folderName.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Put data into cells
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        if (self.resultSearchController.active)
        {
            cell!.textLabel?.text = self.filteredNotes[indexPath.row] as? String
        }
        else
        {
            cell!.textLabel?.text = folderName[indexPath.row] as? String
        }
        
        
        //Set hover color for the Cells
        let bgView : UIView = UIView()
        bgView.backgroundColor = hoverColor
        cell!.selectedBackgroundView = bgView
        
        
        
        return cell!
    }

    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredNotes.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.folderName as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredNotes = array as! [String]
        
        self.tableView.reloadData()

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){}
    
    func showedit(name: String, id: String){
        let editalert = UIAlertController(title: "Edit Folder", message: "Folder name", preferredStyle: UIAlertControllerStyle.Alert)
        let eidtcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
           
        }
        let editesave = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            self.folderobj.edit(self.createfolsername.text! , id2: id)
            self.viewDidLoad()
           
        }
        editalert.addAction(eidtcancel)
        editalert.addAction(editesave)
        editalert.addTextFieldWithConfigurationHandler { createfoldertext -> Void in
            createfoldertext.placeholder = "Folder name"
            createfoldertext.text = name
            self.createfolsername = createfoldertext
        }
        presentViewController(editalert, animated: true) { () -> Void in
            
        }
    }
    
    var addshareNoteshare: ShareNoteShareView!
    
    func closeShareView(sender:UIGestureRecognizer?){
        self.addshareNoteshare.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addshareNoteshare.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }
    
    func showShare(name: String, id: String){
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeShareView:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.view.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        self.addshareNoteshare = ShareNoteShareView(frame: CGRectMake(MainWidth/4 - 45, MainHeight/4, MainWidth/2 + 90, 100))
        self.view.addSubview(self.addshareNoteshare)
    }
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.view.frame.width), (self.view.frame.height)))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func shareNoteShare(sender: UIGestureRecognizer?) {
        self.view.addSubview(self.addshareNoteshare!)
    }
    
    func showalert(id:String){
        let alert = UIAlertController(title: "Delete Folder", message: "Are you sure !", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        let alertdelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            self.folderobj.delete(id)
            
            self.viewDidLoad()
            
        }
        alert.addAction(alertAction)
        alert.addAction(alertdelete)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func sharefolder(id:String){
        let alert = UIAlertController(title: "Share Folder", message: "Emails to Share", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        let alertdelete = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let emailId = self.createfolsername.text!
            
            if(self.isValidEmail(emailId)) {
                print("Proper Email")
                self.folderobj.shareFolder(id, email: self.createfolsername.text!, completion: {(json: JSON) -> () in})
            } else {
                print("Not Proper Email")
//                erroralert.addAction(alertAction2)
//                self.presentViewController(erroralert, animated: true) { () -> Void in }
                
                let createAccountErrorAlert: UIAlertView = UIAlertView()
                
                createAccountErrorAlert.delegate = self
                
                createAccountErrorAlert.title = "Alert"
                createAccountErrorAlert.message = "Invalid Email"
                createAccountErrorAlert.addButtonWithTitle("Ok")
                
                createAccountErrorAlert.show()
                
                let delay = 5.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    createAccountErrorAlert.dismissWithClickedButtonIndex(-1, animated: true)
                })
            }
            self.viewDidLoad()
            
        }
        alert.addAction(alertAction)
        alert.addAction(alertdelete)
        alert.addTextFieldWithConfigurationHandler { createfoldertext -> Void in
            createfoldertext.placeholder = "Enter email(,)"
            self.createfolsername = createfoldertext
        }
        presentViewController(alert, animated: true) { () -> Void in }
    }

    
    @IBAction func createFolder(sender: AnyObject) {
        let createalert = UIAlertController(title: "Create Folder", message: "Folder name", preferredStyle: UIAlertControllerStyle.Alert)
        let createcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        let createsave = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
           
            self.folderobj.create(self.createfolsername.text!)
            self.viewDidLoad()
        }
        createalert.addAction(createcancel)
        createalert.addAction(createsave)
        createalert.addTextFieldWithConfigurationHandler { createfoldertext -> Void in
            createfoldertext.placeholder = "Folder name"
            self.createfolsername = createfoldertext
        }
        
        presentViewController(createalert, animated: true) { () -> Void in
            
        }
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete")
            {
                
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                self.showalert(self.folderId[indexPath.row] as! String)
        }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                self.showedit(self.folderName[indexPath.row] as! String, id: self.folderId[indexPath.row] as! String)
                let firstActivityItem = self.folderName[indexPath.row]
                
        }
        
        func noInternet(){
            print("empty yooooooooo......")
            let alert = UIAlertController(title: "Alert", message: "Can not share this Folder without sync OR No Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                
            }
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true) { () -> Void in }
        }
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Share") {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            if(!self.notesobj.isConnectedToNetwork()){
                noInternet()

            }else{
                if config.isConfigNet(){
                self.folderobj.localtoserver{(json: JSON) -> () in
                    self.folderobj.servertolocal{(json: JSON) -> () in
                        self.notesobj.localtoserver{(json: JSON) -> () in
                            self.notesobj.servertolocal{(json: JSON) -> () in
                        print(strtoll(self.folderId[indexPath.row] as! String,nil,10))
                        let onenote = self.folderobj.findOne(strtoll(self.folderId[indexPath.row] as! String,nil,10))
                        print(onenote)
                        if(onenote![self.folderobj.serverID] == ""){
                            noInternet()
                        }else{
                            self.sharefolder(onenote![self.folderobj.serverID])
                        }
                            }
                        }

                    }
                }
                }else{
                    config.invokeAlertMethod("Sync",msgBody: "Can not Sync. Check your Sync Settings",delegate: "")

                }
            }
            
//            globalFolderId = self.folderId[indexPath.row];
//            self.showShare(self.folderName[indexPath.row] as! String, id: globalFolderId as! String)
        }
        
        deleteAction.backgroundColor = mainColor
        editAction.backgroundColor = mainColor
        shareAction.backgroundColor = mainColor
    
        return [shareAction, deleteAction, editAction]
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let noteView = config.get("note_view");
        switch noteView
        {
            case "1":
            self.performSegueWithIdentifier("noteDetail", sender: self)
            case "2":
            self.performSegueWithIdentifier("noteList", sender: self)
            case "3":
            self.performSegueWithIdentifier("ShowNotes", sender: self)
        default:
            self.performSegueWithIdentifier("ShowNotes", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "noteDetail"){

            let selectedPath = self.tableView!.indexPathForSelectedRow
            
            let vc = segue.destinationViewController as! Detailview
            vc.title = self.folderName[selectedPath!.row] as? String
            selectedFolderToNoteId = (self.folderId[selectedPath!.row] as? String)!
            vc.navigationItem.leftItemsSupplementBackButton = true
            
        }
        if(segue.identifier == "noteList"){

            let selectedPath = self.tableView!.indexPathForSelectedRow
            
            let vc = segue.destinationViewController as! Listview
            vc.title = self.folderName[selectedPath!.row] as? String
            selectedFolderToNoteId = (self.folderId[selectedPath!.row] as? String)!
            
        }
        if(segue.identifier == "ShowNotes"){

            let selectedPath = self.tableView!.indexPathForSelectedRow
            
            let vc = segue.destinationViewController as! cardViewController
            vc.title = self.folderName[selectedPath!.row] as? String
            selectedFolderToNoteId = (self.folderId[selectedPath!.row] as? String)!
            
        }
    }

}