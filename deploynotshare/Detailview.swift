//
//  Detailview.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 04/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import EventKit
import SwiftyJSON

class Detailview: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating, UIViewControllerPreviewingDelegate {

    @IBOutlet weak var detailtableview: UITableView!
    var notesTitle:[String] = []
    var notesId:[Int64] = []
    var modificationTime: [Double] = []
    var noteDesc: [String!] = []
    var color: [String] = []
    var islocked: [Int64] = []
    var noteServerId: [String] = []
    var notesobj = Note()
    var noteName = UITextField()
    let mainColor = PinkColor
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    var resultSearchController = UISearchController!()
    var forceId:Int!
    var searchTable = ""
    var folderobj = Folder()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
                self.getAllNotes()
                self.detailtableview.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewForNotes = self;
        

        
        let note2 = Note()
        
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
        
        let addView = AddCircle(frame: CGRectMake(width/2 - 35, height-134, 70, 70))
        self.view.addSubview(addView)
        
        UILabel.appearance().font = UIFont(name: "Agenda", size: 14)
        
        //Search bar code
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.barTintColor = PinkColor //bar color
        self.resultSearchController.searchBar.translucent = false //Bar translucent false
        self.resultSearchController.searchBar.tintColor = UIColor.whiteColor() //text color
        self.definesPresentationContext = true
        self.detailtableview.tableHeaderView = self.resultSearchController.searchBar
        self.detailtableview.reloadData()
        
        //Clear Empty Cells
        let backgroundView = UIView(frame: CGRectZero)
        self.detailtableview.tableFooterView = backgroundView
        self.detailtableview.backgroundColor = UIColor.clearColor()
        
        //Show search on scroll
        self.detailtableview.setContentOffset(CGPoint(x: 0,y: 44), animated: true)
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            // register UIViewControllerPreviewingDelegate to enable Peek & Pop
            registerForPreviewingWithDelegate(self, sourceView: view)
            
        }else {
            // 3D Touch Unavailable : present alertController or
            // Provide alternatives such as touch and hold..
        }
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("Force Touch is wokring");
        
        guard let indexPath = detailtableview.indexPathForRowAtPoint(location), cell = detailtableview.cellForRowAtIndexPath(indexPath) else { return nil }
        
        print("COUNT: \(self.notesId.count) INDEXPATH = \(indexPath.row)" )
        
        if(indexPath.row >= self.notesId.count) {
            forceId = nil
            return nil
        }
        else
        {
            forceId = indexPath.row;
            selectedNoteId = String(self.notesId[indexPath.row])
            config.set("note_id", value2: String(selectedNoteId))
            let detailview = storyboard!.instantiateViewControllerWithIdentifier("detailViewController") as! detailViewController
            return detailview
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        if(forceId != nil)
        {
            selectedNoteId = String(self.notesId[forceId])
            config.set("note_id", value2: String(selectedNoteId))
            if(loadingCompleted) {
                self.performSegueWithIdentifier("showdetaildetailview", sender: self)
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        searchTable = searchController.searchBar.text!;
        getAllNotes()
        self.detailtableview.reloadData()
    }
    
    func getAllNotes(){
        ViewForNotes = self;
        notesTitle = []
        notesId = []
        modificationTime = []
        color = []
        islocked = []
        noteDesc = []
        noteServerId = []
        
        
            for row in notesobj.find2(searchTable) {
//                print(row[5] as! String!)
                notesTitle.append(row[1] as! String!)
                notesId.append(row[0] as! Int64! )
                modificationTime.append(Double(row[6] as! Int64!) )
                color.append(row[2] as! String!)
                islocked.append(row[3] as! Int64!)
                noteDesc.append(row[5] as! String! )
                noteServerId.append(row[4] as! String!)
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
        ColorNote = String(notesId[indexPath.row])
        
        if(PressCkeck == 0){
            PressCkeck = 1
            let blackOutTap = UITapGestureRecognizer(target: self,action: "closeColorPattern:")
            self.addBlackView()
            blackOut.addGestureRecognizer(blackOutTap)
            blackOut.alpha = 0
            self.view.addSubview(blackOut);
            blackOut.animation.makeAlpha(1).animate(transitionTime);
            
            self.addColorPattern = ColorPattern(frame: CGRectMake(MainWidth/4,MainHeight/4, 300, 200))
            self.addColorPattern.center = CGPointMake(view.frame.size.width  / 2,
                                                      view.frame.size.height / 2)
            self.view.addSubview(self.addColorPattern)
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = detailtableview.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
        
        cell.rightButtons = [
            MGSwipeButton(title: "",icon: UIImage(named:"note_remainder_white"), backgroundColor: mainColor , callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                datetimepopupType  = "reminder"
                selectedNoteId = String(self.notesId[indexPath.row])
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addDateTimeView = DateTime(frame: CGRectMake(self.width/2 ,self.height/2, 300, 500))
                self.addDateTimeView.center = CGPointMake(self.view.frame.size.width / 2,
                    self.view.frame.size.height / 2)
                self.view.addSubview(self.addDateTimeView)
                
                return true

            }),
            MGSwipeButton(title: "",icon: UIImage(named:"note_share_white"), backgroundColor: mainColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print(self.notesId[indexPath.row])
                
                
                if(self.notesId[indexPath.row]==0 || !self.notesobj.isConnectedToNetwork()){
                print("empty yooooooooo......")
                let alert = UIAlertController(title: "Alert", message: "Can not share this note without sync OR No Internet Connection.", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                    
                }
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true) { () -> Void in }
                    
                }else{
                
                selectedNoteId = String(self.notesId[indexPath.row])
                selectedNoteDesc = String(self.noteDesc[indexPath.row])
                selectedName = String(self.notesTitle[indexPath.row])

                    self.notesobj.localtoserver{(json: JSON) -> () in
                        self.notesobj.servertolocal{(json: JSON) -> () in
//                            let onenote = self.notesobj.findOne(strtoll(selectedNoteId,nil,10));
//                            print(onenote)
//                            print(onenote![self.notesobj.serverid]!)
                            //                        self.noteobj.shareNote(onenote![self.noteobj.serverid]!, email: sendemailto, completion: self.resShareNote)
                        }
                    }

                    
                    
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeShareView:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addShareView = ShareView(frame: CGRectMake(self.width/4 - 45,self.height/4, self.width/2 + 90, 200))
                self.view.addSubview(self.addShareView)
                }
                
                return true
            }),
            MGSwipeButton(title: "",icon: UIImage(named:"note_delete_white"), backgroundColor: mainColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                selectedNoteId = String(self.notesId[indexPath.row])
                self.showdelete(indexPath.row)
                
                return true
            }),
            MGSwipeButton(title: "",icon: UIImage(named:"note_move_white"), backgroundColor: mainColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                selectedNoteId = String(self.notesId[indexPath.row])
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeMoveToFolder:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                
                let xpos = (self.width/2) - (300/2);
                let ypos = (self.height/2) - (400/2);
                
                self.addMoveToFolder = MoveToFolder(frame: CGRectMake(xpos,ypos, 300, 200))
                self.view.addSubview(self.addMoveToFolder)
                
                return true
            }),
            MGSwipeButton(title: "",icon: UIImage(named:"note_timebomb_white"), backgroundColor: mainColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                datetimepopupType  = "timebomb"
                selectedNoteId = String(self.notesId[indexPath.row])
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addDateTimeView = DateTime(frame: CGRectMake(self.width/2 ,self.height/2, self.width, 500))
                self.addDateTimeView.center = CGPointMake(self.view.frame.size.width / 2,
                    self.view.frame.size.height / 2)
                self.view.addSubview(self.addDateTimeView)
                
                return true
            }),
            MGSwipeButton(title: "", icon: UIImage(named:"note_lock_white"), backgroundColor: mainColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                selectedNoteId = String(self.notesId[indexPath.row])
                
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
                        self.notesobj.changeLock(1,id2:(String)(self.notesId[indexPath.row]))
                        
                    }else{
                        self.presentViewController(passcodemodal, animated: true, completion: nil)
                        
                    }
                }
                
                
                self.getAllNotes()
                self.detailtableview.reloadData()
                
                return true
            })
        ]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        
        cell.DetailViewTitle.text = notesTitle[indexPath.row] as? String
        cell.DetailDescription.text = (noteDesc[indexPath.row] as? String?)!
        
        cell.DetailViewTitle.font = UIFont(name: "Agenda-Bold", size: 16)
        cell.DetailTimeStamp.font = UIFont(name: "Agenda", size: 11)
        if(islocked[indexPath.row] == 0){
            cell.DetailLock.hidden = true
        }else{
            cell.DetailLock.hidden = false
        }

        let moddate = NSDate(timeIntervalSince1970: self.modificationTime[indexPath.row] as! Double)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle  = .MediumStyle // superset of OP's format
        let str = dateFormatter.stringFromDate(moddate)
        cell.DetailTimeStamp.text = String(str)

        let colorno = color[indexPath.row]
        var celllongPress = UILongPressGestureRecognizer(target: self, action: "colorPattern:")
        cell.addGestureRecognizer(celllongPress)
        cell.backgroundColor = UIColor(rgba: colorno)
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
    
    func showdelete(id:Int){
        let alert = UIAlertController(title: "Delete Note", message: "Are you sure !", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            
        }
        let alertdelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            if(self.islocked[id] == 0){
                selectedNoteIndex = Int(id)
                self.notesobj.delete(selectedNoteId)
                //                self.performSegueWithIdentifier("showdetaillistview", sender: self)
            }else{
                selectedNoteIndex = Int(id)
                
                let passcodemodal = self.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
                
                passcodemodal.setLock = String(self.islocked[id])
                
                let realpasscode = config.get("passcode")
                passcodemodal.lockValue = -1
                passcodemodal.titleName = (self.notesTitle[id] as? String)!
                self.presentViewController(passcodemodal, animated: true, completion: nil)
                
                self.getAllNotes()
                self.detailtableview!.reloadData()
            }

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
    
    
    func closeShareView(sender:UIGestureRecognizer?){
        self.addShareView.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addShareView.removeFromSuperview()
            
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
    var addShareView:ShareView!
    
    /*func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
                self.showedit(self.notesTitle[indexPath.row] as! String, id: self.notesId[indexPath.row] as! String)
                //                let firstActivityItem = self.noteTitle[indexPath.row]
                
        }
        
        
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Share")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
        }
        editAction.backgroundColor = mainColor
        
        return [editAction, deleteAction,lockAction,timeBombAction,moveAction,shareAction]
        
    }*/
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedNoteId = String(self.notesId[indexPath.row])
        print(selectedNoteId)
        config.set("note_id", value2: String(selectedNoteId))
        
        if(islocked[indexPath.row] == 0){
            selectedNoteIndex = Int(indexPath.row)
            self.performSegueWithIdentifier("showdetaildetailview", sender: self)
        }
        else {
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
    
    
    func getselectedNote(val:Int64) {
        selectedNoteIndex = (self.notesId.indexOf(val))!
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
