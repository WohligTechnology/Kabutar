//
//  Detailview.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 04/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class Detailview: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var detailtableview: UITableView!
    var notesTitle:NSMutableArray = []
    var notesId:NSMutableArray = []
    var modificationTime: NSMutableArray = []
    var color: [String] = []
    var islocked: [Int64] = []
    var notesobj = Note()
    var noteName = UITextField()
    let mainColor = PinkColor
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewForNotes = self;
        
        getAllNotes()
        
        if(isInsideFolder == 0)
        {
            self.setNavigationBarItem()
        }
        else
        {
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
            self.navigationController?.navigationBar.translucent = false
            self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
            self.navigationController?.toolbar.barTintColor = PinkColor
            self.navigationController?.navigationBar.barTintColor = PinkColor
        }

        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let bottomLine = UIView(frame: CGRectMake(0,height-114, width , 1))
        bottomLine.backgroundColor = PinkColor
        self.view.addSubview(bottomLine)
        
        let addView = AddCircle(frame: CGRectMake(width/2 - 35, height-134, 70, 70))
        self.view.addSubview(addView)
    }
    
    func getAllNotes(){
        ViewForNotes = self;
        notesTitle = []
        notesId = []
        modificationTime = []
        color = []
        islocked = []
        
        
        
        if(selectedFolderToNoteId==""){
            for row in notesobj.find() {
                notesTitle.addObject(row[notesobj.title]!)
                notesId.addObject(String(row[notesobj.id]))
                modificationTime.addObject(Double(row[notesobj.modificationTime]))
                color.append(row[notesobj.color]!)
                islocked.append(row[notesobj.islocked])
                
            }
            
        } else {
            for row in notesobj.getNotesFolder(selectedFolderToNoteId) {
                notesTitle.addObject(row[notesobj.title]!)
                notesId.addObject(String(row[notesobj.id]))
                modificationTime.addObject(Double(row[notesobj.modificationTime]))
                color.append(row[notesobj.color]!)
                islocked.append(row[notesobj.islocked])
                
            }
            
        }

    }
    
    @IBOutlet weak var detailView: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notesTitle.count
    }
    
    var PressCkeck = 0
    var addColorPattern:ColorPattern!
    
    
    func closeColorPattern(sender:UIGestureRecognizer?){
        PressCkeck = 0
        self.addColorPattern.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addColorPattern.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }
    func colorPattern(sender: UILongPressGestureRecognizer)
    {
        let pass = sender.locationInView(self.detailtableview)
        let indexPath: NSIndexPath = self.detailtableview.indexPathForRowAtPoint(pass)!
        ColorNote = notesId[indexPath.row] as! String
        
        
        if(PressCkeck == 0){
            PressCkeck = 1
            let blackOutTap = UITapGestureRecognizer(target: self,action: "closeColorPattern:")
            self.addBlackView()
            blackOut.addGestureRecognizer(blackOutTap)
            blackOut.alpha = 0
            self.view.addSubview(blackOut);
            blackOut.animation.makeAlpha(1).animate(transitionTime);
            
            self.addColorPattern = ColorPattern(frame: CGRectMake(MainWidth/4 - 50,MainHeight/4, 300, 150))
            self.view.addSubview(self.addColorPattern)
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = detailtableview.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
        cell.DetailViewTitle.text = notesTitle[indexPath.row] as? String
        cell.DetailDescription.text = notesTitle[indexPath.row] as? String
        if(islocked[indexPath.row] == 0){
            cell.DetailLock.hidden = true
        }else{
            cell.DetailLock.hidden = false
        }
        
        let moddate = NSDate(timeIntervalSince1970: self.modificationTime[indexPath.row] as! Double)
    
        cell.DetailTimeStamp.text = String(moddate)

        let colorno = color[indexPath.row]
        var celllongPress = UILongPressGestureRecognizer(target: self, action: "colorPattern:")
        cell.addGestureRecognizer(celllongPress)
        cell.backgroundColor = NoteColors[Int(colorno)!]
        return cell
        
    }
    
    
    func showedit(name: String, id: String){
        let editalert = UIAlertController(title: "Edit Note", message: "Note name", preferredStyle: UIAlertControllerStyle.Alert)
        let eidtcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
           
        }
        let editesave = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            self.notesobj.changeTitle(self.noteName.text!,id2:id)
            self.getAllNotes()
            self.detailtableview!.reloadData()
            
        }
        editalert.addAction(eidtcancel)
        editalert.addAction(editesave)
        editalert.addTextFieldWithConfigurationHandler { createfoldertext -> Void in
            createfoldertext.placeholder = "Note name"
            createfoldertext.text = name
            self.noteName = createfoldertext
        }
        presentViewController(editalert, animated: true) { () -> Void in
            
        }
    }
    
    func showdelete(id:String){
        let alert = UIAlertController(title: "Delete Note", message: "Are you sure !", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            
        }
        let alertdelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            self.notesobj.delete(id)
            self.getAllNotes()
            self.detailtableview!.reloadData()
        }
        alert.addAction(alertAction)
        alert.addAction(alertdelete)
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
                selectedNoteId = self.notesId[indexPath.row] as! String
                
                let passcodemodal = self.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
                
                //                ConfigObj.set("demo", value2: "testing")
                passcodemodal.setLock = String(self.islocked[indexPath.row])
                
                let realpasscode = config.get("passcode")
                if(realpasscode == ""){
                    passcodemodal.lockValue = 0
                    self.presentViewController(passcodemodal, animated: true, completion: nil)
                }else{
                    passcodemodal.lockValue = 1
                    if(self.islocked[indexPath.row] == 0){
                        self.notesobj.changeLock(1,id2:self.notesId[indexPath.row] as! String)
                        
                    }else{
                        self.presentViewController(passcodemodal, animated: true, completion: nil)
                        
                    }
                }
                
                
                self.getAllNotes()
                self.detailtableview.reloadData()
                
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
                
                self.addDateTimeView = DateTime(frame: CGRectMake(10,self.height/2 - 300, self.width-20, 500))
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedNoteId = self.notesId[indexPath.row] as! String
        config.set("note_id", value2: String(selectedNoteId))
        
        if(islocked[indexPath.row] == 0){
            self.performSegueWithIdentifier("showdetaildetailview", sender: self)
        }else{
            selectedNoteId = self.notesId[indexPath.row] as! String
            selectedNoteIndex = Int(indexPath.row)
            
            let passcodemodal = self.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
            
            passcodemodal.setLock = String(self.islocked[indexPath.row])
            
            let realpasscode = config.get("passcode")
            passcodemodal.lockValue = 3
            passcodemodal.titleName = (self.notesTitle[indexPath.row] as? String)!
            presentViewController(passcodemodal, animated: true, completion: nil)
            
            self.getAllNotes()
            self.detailtableview.reloadData()

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showdetaildetailview"){
            let indexPaths = self.detailtableview!.indexPathForSelectedRow
            let vc = segue.destinationViewController as! detailViewController
            vc.title = self.notesTitle[selectedNoteIndex] as? String
            
        }
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
