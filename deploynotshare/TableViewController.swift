//
//  TableViewController.swift
//  NoteShare
//
//  Created by Tushar Sachde on 21/10/15.
//  Copyright © 2015 Tushar Sachde. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    let mainColor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    let hoverColor = UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    var folderName:NSMutableArray = []
    var folderId:NSMutableArray = []
    var notes = ["BOTANY: THE CLASSIFICATION OF MANY BOX", "Physics Theory Links", "Maths", "Computer Science", "Graphics"]
    var filteredNotes = [String]()
    var resultSearchController = UISearchController!()
    var createfolsername = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
        
        let a = Folder();
        for row in a.find() {
            folderName.addObject(row[a.name]!)
            folderId.addObject(String(row[a.id]))
        }
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
            return self.folderName.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Put data into cells
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        //Set hover color for the Cells
        let bgView : UIView = UIView()
        bgView.backgroundColor = hoverColor
        cell!.selectedBackgroundView = bgView
        
        cell!.textLabel?.text = folderName[indexPath.row] as? String
        
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
    
    func showalert(){
        let alert = UIAlertController(title: "Hello!", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Ok press")
        }
        let alertdelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Delete Press")
            print(firstActivityItem)
        }
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            //TextField configuration
            textField.placeholder = "Folder Name"
            
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
            var a = Folder()
            a.create(self.createfolsername.text!)
            self.tableView.reloadData()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
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
                print(self.folderId[indexPath.row])
                let firstActivityItem = self.notes[indexPath.row]
                self.showalert()
//                    let deletealert = UIAlertController(title: "Hello", message: "message", preferredStyle: UIAlertControllerStyle.Alert)
//                    presentViewController(deletealert, animated: true) { () -> void in}
                
                
            }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
                let firstActivityItem = self.notes[indexPath.row]
                
        }
        
        //deleteAction.backgroundColor = mainColor
        editAction.backgroundColor = mainColor
    
        return [deleteAction, editAction]
        
    }

}