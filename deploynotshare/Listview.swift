//
//  Listview.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 04/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import SystemConfiguration
import SwiftyJSON

class Listview: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating, UIViewControllerPreviewingDelegate {

    @IBOutlet weak var listView: UITableView!
    var forceId:Int!
    let mainColor = PinkColor
    var notesTitle:[String] = []
    var notesId:[Int64] = []
    var noteServerId:[String] = []
    var notesobj = Note()
    var color: [String] = []
    var islocked: [Int64] = []
    var noteDesc: [String!] = []
    var noteName = UITextField()
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    var resultSearchController = UISearchController!()
    let configobj = Config()
    
    var searchTable = ""
    
    @IBOutlet weak var ListViewLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if(notesobj.isConnectedToNetwork())
        {
        dispatch_async(dispatch_get_main_queue(),{
            self.notesobj.localtoserver{(json: JSON) -> () in
                self.notesobj.servertolocal{(json: JSON) -> () in
                    self.getAllNotes()
                    self.listView.reloadData()
                }
                
            }
        })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewForNotes = self;
        
        
        getAllNotes()
//        ConfigObj.set("passcode", value2: "1234")
        
        let addView = AddCircle(frame: CGRectMake(width/2 - 35, height-134, 70, 70))
        self.view.addSubview(addView)

        //Search bar code
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.barTintColor = PinkColor //bar color
        self.resultSearchController.searchBar.translucent = false //Bar translucent false
        self.resultSearchController.searchBar.tintColor = UIColor.whiteColor() //text color
        self.definesPresentationContext = true
        self.listView.tableHeaderView = self.resultSearchController.searchBar
        self.listView.reloadData()
        
        //Clear Empty Cells
        let backgroundView = UIView(frame: CGRectZero)
        self.listView.tableFooterView = backgroundView
        self.listView.backgroundColor = UIColor.clearColor()
        
        //Show search on scroll
        self.listView.setContentOffset(CGPoint(x: 0,y: 44), animated: true)
        
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
        guard let indexPath = listView.indexPathForRowAtPoint(location), cell = listView.cellForRowAtIndexPath(indexPath) else { return nil }
        
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
        }    }
    
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
        self.listView.reloadData()
    }
    
    
    
    func getAllNotes(){
        notesTitle = []
        notesId = []
        color = []
        islocked = []
        noteServerId = []
        
        
        ViewForNotes = self;
        
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

        
            for row in notesobj.find2(searchTable) {
                notesTitle.append(row[1] as! String!)
                notesId.append(row[0] as! Int64! )
               
                color.append(row[2] as! String!)
                islocked.append(row[3] as! Int64!)
                noteDesc.append(row[4] as! String!)
                noteServerId.append(row[4] as! String)
                
        }
            
        }

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
        let pass = sender.locationInView(self.listView)
        let indexPath: NSIndexPath = self.listView.indexPathForRowAtPoint(pass)!
        ColorNote = String(notesId[indexPath.row])
        
        
        if(PressCkeck == 0){
            PressCkeck = 1
            let blackOutTap = UITapGestureRecognizer(target: self,action: "closeColorPattern:")
            self.addBlackView()
            blackOut.addGestureRecognizer(blackOutTap)
            blackOut.alpha = 0
            self.view.addSubview(blackOut);
            blackOut.animation.makeAlpha(1).animate(transitionTime);
            
            self.addColorPattern = ColorPattern(frame: CGRectMake(MainWidth/4 - 50,MainHeight/4, 300, 200))
            self.view.addSubview(self.addColorPattern)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = listView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
        
        cell.rightButtons = [
            MGSwipeButton(title: "",icon: UIImage(named: "note_remainder_white"), backgroundColor: mainColor , callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                self.notesobj.localtoserver{(json: JSON) -> () in }
                self.viewDidLoad()
                datetimepopupType = "reminder"
                
                selectedNoteId = String(self.notesId[indexPath.row])
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addDateTimeView = DateTime(frame: CGRectMake(self.width-335,self.height-600, 300, 500))
                self.view.addSubview(self.addDateTimeView)
                
                return true
            }),
            MGSwipeButton(title: "",icon: UIImage(named: "note_share_white"), backgroundColor: mainColor, callback : {
                (sender: MGSwipeTableCell!) -> Bool in
                if(self.notesId[indexPath.row]==0){
                    print("empty yooooooooo......")
                    let alert = UIAlertController(title: "Alert", message: "Can not share this note without sync", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                        
                    }
                    alert.addAction(alertAction)
                    self.presentViewController(alert, animated: true) { () -> Void in }
                    
                }else{
                    
                selectedNoteId = String(self.notesId[indexPath.row])
                selectedNoteDesc = String(self.noteDesc[indexPath.row])
                selectedName = String(self.notesTitle[indexPath.row])
                print(selectedNoteId)
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeShareView:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
        
                self.addShareView = ShareView(frame: CGRectMake(self.width/4 - 45,self.height/4, self.width/2 + 90, 200))
                self.view.addSubview(self.addShareView)
                
                }

                return true;
            }),
            MGSwipeButton(title: "",icon: UIImage(named:"note_delete_white"), backgroundColor: mainColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                    selectedNoteId = String(self.notesId[indexPath.row])
                    self.showdelete(indexPath.row)
                self.getAllNotes()
                self.listView.reloadData()
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
                
                self.addMoveToFolder = MoveToFolder(frame: CGRectMake(self.width/4 - 45,self.height/4 - 100, 300, 300))
                self.view.addSubview(self.addMoveToFolder)
                return true;
            
            }),
            MGSwipeButton(title: "",icon: UIImage(named:"note_timebomb_white"), backgroundColor: mainColor,callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                datetimepopupType = "timebomb"
                
                selectedNoteId = String(self.notesId[indexPath.row])
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeTimeBomb:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addDateTimeView = DateTime(frame: CGRectMake(self.width-335,self.height-600, 300, 500))
                self.view.addSubview(self.addDateTimeView)
                
                
                return true;
            }),
            MGSwipeButton(title: "", icon: UIImage(named:"note_lock_white"), backgroundColor: mainColor, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                selectedNoteId = String(self.notesId[indexPath.row])
                
                let passcodemodal = self.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
                
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
                self.listView.reloadData()
                
                
                return true
                
            })
        ]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        
        cell.ListViewTitle.text = notesTitle[indexPath.row] as? String
        if(islocked[indexPath.row] == 0){
            cell.ListLock.hidden = true
        }else{
            cell.ListLock.hidden = false
        }
        
        let colorno = color[indexPath.row]
        
        var celllongPress = UILongPressGestureRecognizer(target: self, action: "colorPattern:")
        
        cell.addGestureRecognizer(celllongPress)
        
//        var celllongPress = UILongPressGestureRecognizer(target: self, action: "colorPattern:")
//        cell.addGestureRecognizer(celllongPress)
        
//        cell.backgroundColor? = NoteColors[Int(colorno)!] 
        
        return cell
        
    }
    
    func showedit(name: String, id: String){
        let editalert = UIAlertController(title: "Edit Note", message: "Note name", preferredStyle: UIAlertControllerStyle.Alert)
        let eidtcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
           
        }
        let editesave = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
          
            self.notesobj.changeTitle(self.noteName.text!,id2:id)
            self.getAllNotes()
            self.listView!.reloadData()
            
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
    
    func closeShareView(sender:UIGestureRecognizer?){
        self.addShareView.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addShareView.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }

    
    func showdelete(id:Int){
        let alert = UIAlertController(title: "Delete Note", message: "Are you sure !", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
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
                self.listView.reloadData()
            }

//            self.notesobj.delete(id)
            self.getAllNotes()
            self.listView!.reloadData()
        }
        alert.addAction(alertAction)
        alert.addAction(alertdelete)
        presentViewController(alert, animated: true) { () -> Void in }
    }

    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.view.frame.width), (self.view.frame.height)))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
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
    
    func closeColorPaper(sender:UIGestureRecognizer?){
        self.addColorPaper.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addColorPaper.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }
    
    var addDateTimeView:DateTime!
    var addMoveToFolder:MoveToFolder!
    var addColorPaper:ColorPaper!
    var addShareView:ShareView!
    
   /*
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
                self.listView.reloadData()
                
                
        }
        
        let timeBombAction = UITableViewRowAction(style: .Normal, title: "Bomb")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
        }
        
        let moveAction = UITableViewRowAction(style: .Normal, title: "Move")
            {
                (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
                
                selectedNoteId = self.notesId[indexPath.row] as! String
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
                
                selectedNoteId = self.notesId[indexPath.row] as! String
                let blackOutTap = UITapGestureRecognizer(target: self,action: "closeColorPaper:")
                self.addBlackView()
                blackOut.addGestureRecognizer(blackOutTap)
                blackOut.alpha = 0
                self.view.addSubview(blackOut);
                blackOut.animation.makeAlpha(1).animate(transitionTime);
                
                self.addColorPaper = ColorPaper(frame: CGRectMake(self.width/4 - 45,self.height/2 - 150, 300, 150))
                self.view.addSubview(self.addColorPaper)
                
        }
        editAction.backgroundColor = mainColor
        
        return [editAction, deleteAction,lockAction,timeBombAction,moveAction,shareAction]
        
    }

    */
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedNoteId = String(self.notesId[indexPath.row])
        config.set("note_id", value2: String(selectedNoteId))
        
        if(islocked[indexPath.row] == 0){
            selectedNoteIndex = Int(indexPath.row)
            self.performSegueWithIdentifier("showdetaillistview", sender: self)
        }else{
            selectedNoteIndex = Int(indexPath.row)

            let passcodemodal = self.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
            
            passcodemodal.setLock = String(self.islocked[indexPath.row])
            
            let realpasscode = config.get("passcode")
            passcodemodal.lockValue = 3
            passcodemodal.titleName = (self.notesTitle[indexPath.row] as? String)!
            presentViewController(passcodemodal, animated: true, completion: nil)
            
            self.getAllNotes()
            self.listView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showdetaillistview"){
            let indexPaths = self.listView!.indexPathForSelectedRow
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
