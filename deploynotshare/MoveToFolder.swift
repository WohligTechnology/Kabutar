//
//  MoveToFolder.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 06/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class MoveToFolder: UIView,UITableViewDataSource,UITableViewDelegate{
    
    var tableView: UITableView!
    var labeltext = ["BIOLOGY","PYSICS","MATHS","ECOLOGY","BIOLOGY","PYSICS","MATHS","ECOLOGY"]
    var folderobj = Folder()
    var noteobj = Note()
    var folderName: NSMutableArray = []
    var folderId: NSMutableArray = []
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folderName.count
    }
    
    
    
    @IBOutlet var MoveToFolderView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        
        for row in folderobj.find() {
            folderName.addObject(row[folderobj.name]!)
            folderId.addObject(String(row[folderobj.id]))
        }
        
        
        let nib = UINib(nibName: "MoveToFolder", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        MoveToFolderView.frame = bounds
        MoveToFolderView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(MoveToFolderView);
        
        
        tableView = UITableView(frame: CGRectMake(0, 44, 300, 300), style: UITableViewStyle.Plain)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        MoveToFolderView.addSubview(tableView)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = folderName[indexPath.row] as! String
        return cell
        
    }
    
    func moveToSelectedFolder(noteID:String,folderID:String){
        print(noteID);
        print(folderID);
        noteobj.changeNoteFolder(folderID, id2: noteID)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.removeFromSuperview()
        print("Check this");
        
        let checkstatus = config.get("note_view")
        print(checkstatus);
        if(checkstatus == "2"){
            let mainview = ViewForNotes as! Listview
            print(selectedNoteId)
            moveToSelectedFolder(selectedNoteId,folderID: folderId[indexPath.row] as! String)
            mainview.getAllNotes()
            mainview.listView.reloadData()
            mainview.closeMoveToFolder(nil);
        } else if(checkstatus == "3"){
//            let mainview = ViewForNotes as! cardViewController
//            moveToSelectedFolder(selectedNoteId,folderID: folderId[indexPath.row] as! String)
//            mainview.closeMoveToFolder(nil);
        } else if(checkstatus == "1" || checkstatus == ""){
            let mainview = ViewForNotes as! Detailview
            moveToSelectedFolder(selectedNoteId,folderID: folderId[indexPath.row] as! String)
            print("detail reloaded")
            mainview.getAllNotes()
            mainview.detailtableview.reloadData()
            mainview.closeMoveToFolder(nil);
        }
        
        self.removeFromSuperview()
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
