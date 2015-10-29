//
//  detailViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 23/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet weak var detailtext: UILabel!
    @IBOutlet weak var detaildescription: UILabel!
    var dtext = UILabel()
    var ddescription = UILabel()
    override func viewDidLoad() {
        print("detail view")
        super.viewDidLoad()
        self.detailtext?.text = self.dtext.text
        self.detaildescription?.text = self.ddescription.text

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
