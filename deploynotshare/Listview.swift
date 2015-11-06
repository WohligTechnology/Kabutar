//
//  Listview.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 04/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class Listview: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var listView: UITableView!
    var folderName:NSMutableArray = []
    var folderId:NSMutableArray = []
    var folderobj = Folder()
    override func viewDidLoad() {
        super.viewDidLoad()
        let folderobj = Folder()
        for row in folderobj.find() {
            folderName.addObject(row[folderobj.name]!)
            folderId.addObject(String(row[folderobj.id]))
        }
        print(folderName)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folderName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = listView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        cell!.textLabel?.text = folderName[indexPath.row] as? String
        return cell!
        
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
