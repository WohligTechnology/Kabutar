//
//  TableViewController.swift
//  NoteShare
//
//  Created by Tushar Sachde on 21/10/15.
//  Copyright © 2015 Tushar Sachde. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    let mainColor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    let hoverColor = UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    var noteTitle:NSMutableArray = []
    var noteId:NSMutableArray = []
    var filteredNotes = [String]()
    var resultSearchController = UISearchController!()
    var createfolsername = UITextField()
    var noteobj = Folder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTitle = []
        noteId = []
        
        for row in noteobj.find() {
            noteTitle.addObject(row[noteobj.name]!)
            noteId.addObject(String(row[noteobj.id]))
        }
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
        
        
        
        //Clear Empty Cells
        let backgroundView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = backgroundView
        self.tableView.backgroundColor = UIColor.clearColor()
        
        //Show search on scroll
        self.tableView.setContentOffset(CGPoint(x: 0,y: 44), animated: true)
        
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
            return self.noteTitle.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Put data into cells
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        if (self.resultSearchController.active)
        {
            print("in if")
            cell!.textLabel?.text = self.filteredNotes[indexPath.row] as? String
        }
        else
        {
            print("in else")
            cell!.textLabel?.text = noteTitle[indexPath.row] as? String
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
        let array = (self.noteTitle as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredNotes = array as! [String]
        
        self.tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func showedit(name: String, id: String){
        let editalert = UIAlertController(title: "Edit Folder", message: "Folder name", preferredStyle: UIAlertControllerStyle.Alert)
        let eidtcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("cancel")
        }
        let editesave = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print(self.createfolsername.text)
//            self.noteobj.edit(self.createfolsername.text! , id2: id)
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
        let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Ok press")
        }
        let alertdelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Delete Press")
            print(id)
            self.noteobj.delete(id)
            
            self.viewDidLoad()
            
        }
        alert.addAction(alertdelete)
        alert.addAction(alertAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    @IBAction func createFolder(sender: AnyObject) {
        let createalert = UIAlertController(title: "Create Folder", message: "Folder name", preferredStyle: UIAlertControllerStyle.Alert)
        let createcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("cancel")
        }
        let createsave = UIAlertAction(title: "create", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print(self.createfolsername.text)
//            let name= self.createfolsername.text;
//            self.noteobj.create(name,"background","111",1,1,"Paper",reminderTime2:Int64,serverid2:String,tags2:String,timebomb2:Int64) {
            
//            self.noteobj.create(self.createfolsername.text!,background2:"background",color2:"111",folder2: 1,islocked2: 1,paper2: "a",reminderTime2: 2,serverid2: "dfa",tags2: "tab",timebomb2: 23)
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
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete")
            {
                
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                self.showalert(self.noteId[indexPath.row] as! String)
        }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                self.showedit(self.noteTitle[indexPath.row] as! String, id: self.noteId[indexPath.row] as! String)
                let firstActivityItem = self.noteTitle[indexPath.row]
                
        }
        
        //deleteAction.backgroundColor = mainColor
        editAction.backgroundColor = mainColor
        
        return [deleteAction, editAction]
        
    }
    
}