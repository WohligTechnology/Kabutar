//
//  MenuListViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 30/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class MenuListViewController:  UITableViewController {

    var mainViewController: UIViewController!
    
    @IBOutlet weak var profileimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileimage!.layer.cornerRadius = self.profileimage.frame.size.width / 5
        self.profileimage.clipsToBounds = true
        self.profileimage.layer.borderWidth = 2.0
        self.profileimage.layer.borderColor = UIColor.whiteColor().CGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
