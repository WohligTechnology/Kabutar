//
//  TableViewController.swift
//  NoteShare
//
//  Created by Tushar Sachde on 21/10/15.
//  Copyright © 2015 Tushar Sachde. All rights reserved.
//

import UIKit
var selectedFolderToNoteId: String = ""

var FolderViewController : TableViewController!
var last_navigation:UINavigationController!
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let mainColor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    let hoverColor = UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    var folderName:NSMutableArray = []
    var folderId:NSMutableArray = []
    var filteredNotes = [String]()
    var resultSearchController = UISearchController!()
    var createfolsername = UITextField()
    var folderobj = Folder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        
        FolderViewController = self;
        
        folderName = []
        folderId = []
        let a = Folder();
        for row in a.find() {
            folderName.addObject(row[a.name]!)
            folderId.addObject(String(row[a.id]))
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
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
        
        //deleteAction.backgroundColor = mainColor
        editAction.backgroundColor = mainColor
    
        return [deleteAction, editAction]
        
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