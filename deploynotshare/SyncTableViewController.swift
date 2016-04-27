//
//  SyncTableViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 16/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import SwiftyJSON

class SyncTableViewController: UITableViewController {

    @IBOutlet weak var cellWifi: UITableViewCell!
    @IBOutlet weak var cellMobileData: UITableViewCell!
    @IBOutlet weak var cellBoth: UITableViewCell!
    var notesobj = Note()
    var folderobj = Folder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch(config.get("sync_via")){
            case "0":
                self.cellWifi.accessoryType = UITableViewCellAccessoryType.Checkmark
            case "1":
                self.cellMobileData.accessoryType = UITableViewCellAccessoryType.Checkmark
            case "2":
                self.cellBoth.accessoryType = UITableViewCellAccessoryType.Checkmark
            default : break
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var previousCheckedIndex = 0
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.section)
        if indexPath.section == 0 {
            if (indexPath.row != previousCheckedIndex) {
                var cell: UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
                if (cell.accessoryType == UITableViewCellAccessoryType.None) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    if (previousCheckedIndex != indexPath.row) {
                        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: previousCheckedIndex, inSection: 0))!
                        cell.accessoryType = UITableViewCellAccessoryType.None
                        previousCheckedIndex = indexPath.row
                        config.set("sync_via", value2: String(indexPath.row))
                    }
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                
                tableView.reloadData()
            }
        }else{
            if config.isConfigNet() {
                self.notesobj.localtoserver{(json: JSON) -> () in
                    self.notesobj.servertolocal{(json: JSON) -> () in
                        config.invokeAlertMethod("Sync",msgBody: "Sync Successful",delegate:"")

                    }}
                
                self.folderobj.localtoserver{(json: JSON) -> () in
                    self.folderobj.servertolocal{(json: JSON) -> () in}}
                
            }else{
                config.invokeAlertMethod("Sync",msgBody: "Can not Sync. Check your Sync Settings",delegate:"")
            }
            

        }
        
    }


    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
