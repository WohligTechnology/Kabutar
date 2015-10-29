//
//  PasswordViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 28/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var firstbox: UILabel!
    @IBOutlet weak var secondbox: UILabel!
    @IBOutlet weak var thirdbox: UILabel!
    @IBOutlet weak var fourthbox: UILabel!
//    @IBOutlet var PassView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstbox.layer.borderWidth = 1.0
        self.firstbox.layer.borderColor = UIColor.whiteColor().CGColor
        self.secondbox.layer.borderWidth = 1.0
        self.secondbox.layer.borderColor = UIColor.whiteColor().CGColor
        self.thirdbox.layer.borderWidth = 1.0
        self.thirdbox.layer.borderColor = UIColor.whiteColor().CGColor
        self.fourthbox.layer.borderWidth = 1.0
        self.fourthbox.layer.borderColor = UIColor.whiteColor().CGColor
        
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
