//
//  ThinkViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 28/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class ThinkViewController: UIViewController {
    
//    var mainViewController: UIViewController!

    @IBOutlet weak var saysomething: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setNavigationBarItem()
        self.saysomething.layer.borderWidth = 2
        self.saysomething.layer.borderColor = UIColor.brownColor().CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitFeedback(sender: AnyObject) {
        
        let params = ["user": "560fc12ca89c4c8f043a01c7", "email": "chintan@wohlig.com", "text": saysomething.text]
        do {
            let opt = try HTTP.POST(ServerURL+"feed/save", parameters: params)
            opt.start { response in
                print(response.data);
                
                let json = JSON(data: response.data)
                print(json)
                //do things...
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
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
