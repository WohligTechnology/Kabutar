//
//  SecurityViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 16/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController {

    @IBOutlet weak var dashStack: UIStackView!
    @IBOutlet weak var firstTextBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstTextBox.becomeFirstResponder()
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
