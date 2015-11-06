//
//  Detailview.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 04/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class Detailview: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var notesTitle:NSMutableArray = []
    var notesId:NSMutableArray = []
    var notesobj = Note()
    var noteName = UITextField()
    let mainColor = PinkColor
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewForNotes = self;
        
        self.setNavigationBarItem()
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        for row in notesobj.find() {
            notesTitle.addObject(row[notesobj.title]!)
            notesId.addObject(String(row[notesobj.id]))
        }
        let bottomLine = UIView(frame: CGRectMake(0,height-114, width , 1))
        bottomLine.backgroundColor = PinkColor
        self.view.addSubview(bottomLine)
        
        let addView = AddCircle(frame: CGRectMake(width/2 - 35, height-134, 70, 70))
        self.view.addSubview(addView)
    }
    @IBOutlet weak var detailView: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notesTitle.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = detailView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        cell!.textLabel?.text = notesTitle[indexPath.row] as? String
        cell!.detailTextLabel?.text = notesId[indexPath.row] as? String
        return cell!
        
    }
    
    
    func showedit(name: String, id: String){
        let editalert = UIAlertController(title: "Edit Folder", message: "Folder name", preferredStyle: UIAlertControllerStyle.Alert)
        let eidtcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("cancel")
        }
        let editesave = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print(self.noteName.text)
            self.notesobj.edit(self.noteName.text!,background2:"ddsf",color2:"asd",folder2:1,islocked2:2,paper2:"demo",reminderTime2:1,serverid2:"df",tags2:"dsf",timebomb2:0,id2:id)
            self.viewDidLoad()
            
        }
        editalert.addAction(eidtcancel)
        editalert.addAction(editesave)
        editalert.addTextFieldWithConfigurationHandler { createfoldertext -> Void in
            createfoldertext.placeholder = "Folder name"
            createfoldertext.text = name
            self.noteName = createfoldertext
        }
        presentViewController(editalert, animated: true) { () -> Void in
            
        }
    }
    
    func showdelete(id:String){
        let alert = UIAlertController(title: "Delete Folder", message: "Are you sure !", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Ok press")
        }
        let alertdelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("Delete Press")
            print(id)
            self.notesobj.delete(id)
            
            self.viewDidLoad()
            
        }
        alert.addAction(alertdelete)
        alert.addAction(alertAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }

    func closeTimeBomb(sender:UIGestureRecognizer?){
        self.addDateTimeView.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addDateTimeView.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }
    
    
    
    func closeMoveToFolder(sender:UIGestureRecognizer?){
        self.addMoveToFolder.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addMoveToFolder.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }
    

    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.view.frame.width), (self.view.frame.height)))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    var addDateTimeView:DateTime!
    var addMoveToFolder:MoveToFolder!
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
                self.showedit(self.notesTitle[indexPath.row] as! String, id: self.notesId[indexPath.row] as! String)
                //                let firstActivityItem = self.noteTitle[indexPath.row]
                
        }
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                self.showdelete(self.notesId[indexPath.row] as! String)
                
                
        }
        
        let lockAction = UITableViewRowAction(style: .Normal, title: "Lock")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
        }
        
        let timeBombAction = UITableViewRowAction(style: .Normal, title: "Bomb")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addDateTimeView = DateTime(frame: CGRectMake(self.width-335,self.height-600, 300, 500))
                self.view.addSubview(self.addDateTimeView)
        }
        
        let moveAction = UITableViewRowAction(style: .Normal, title: "Move")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeMoveToFolder:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addMoveToFolder = MoveToFolder(frame: CGRectMake(self.width/4 - 45,self.height/4 - 100, 300, 300))
                self.view.addSubview(self.addMoveToFolder)
        }
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Share")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
        }
        editAction.backgroundColor = mainColor
        
        return [editAction, deleteAction,lockAction,timeBombAction,moveAction,shareAction]
        
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
