//
//  SettingViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 14/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    
}
