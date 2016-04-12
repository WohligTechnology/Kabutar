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
    var keyboardHeight: CGFloat!
    var keyboardOn = false

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tellusLabel: UILabel!
    @IBOutlet weak var saysomething: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
//        self.setNavigationBarItem()
        self.tellusLabel.font = UIFont(name: "Agenda", size: 18)
        self.saysomething.layer.borderWidth = 2
        self.saysomething.layer.borderColor = UIColor.brownColor().CGColor
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name:UIKeyboardWillHideNotification, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitFeedback(sender: AnyObject) {
        let params:Dictionary<String,AnyObject> = ["user": config.get("user_id"), "email": "chintan@wohlig.com", "text": saysomething.text]
        
        request.POST(ServerURL+"feed/save", parameters: params, completionHandler: {(response: HTTPResponse) in
            
            let json = JSON(data: response.responseObject as! NSData)
            print(json);
        })
        
        do {
            //            let opt = try HTTP.POST(ServerURL+"feed/save", parameters: params)
            //            opt.start { response in
            //                print(response.data);
            //
            //                let json = JSON(data: response.data)
            //                print(json)
            //                //do things...
            //            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        self.keyboardOn = true;
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        keyboardOn = false
        let info = notification.userInfo!
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
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
