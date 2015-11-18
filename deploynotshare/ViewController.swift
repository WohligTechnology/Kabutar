//
//  ViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 21/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


//import SwiftHTTP'



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FBSDKLoginButtonDelegate {

    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var nametext: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            if (FBSDKAccessToken.currentAccessToken() == nil)
            {
                print("Not logged in..")
            }
            else
            {
                print("Logged in..")
            }
            
            var loginButton = FBSDKLoginButton()
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.center = self.view.center
            loginButton.delegate = self
            self.view.addSubview(loginButton)
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
//        self.profileimage!.layer.cornerRadius = self.profileimage.frame.size.width / 2.0
//        self.profileimage.clipsToBounds = true
//        self.profileimage.layer.borderWidth = 2.0
//        self.profileimage.layer.borderColor = UIColor.whiteColor().CGColor
        
//        let border = CALayer()
//        let width = CGFloat(2.0)
        //border.borderColor = UIColor.whiteColor().CGColor
        //border.frame = CGRect(x: 0, y: nametext.frame.size.height - width, width:  nametext.frame.size.width, height: nametext.frame.size.height)
        
//        border.borderWidth = width
//        nametext.layer.addSublayer(border)
//        nametext.layer.masksToBounds = true
//                do {
//            let opt = try HTTP.GET("http://wohlig.co.in/wordpresstest/wp-json")
//            opt.start { response in
//                if let err = response.error {
//                    print("error: \(err.localizedDescription)")
//                    return //also notify app of failure as needed
//                }
//                let json = JSON(data: response.data)
//                print(json["routes"])
//                //print("data is: \(response.data)") access the response of the data with response.data
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            print("Login complete.")
            print(result.token.tokenString);
            self.performSegueWithIdentifier("showNew", sender: self)
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User logged out...")
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    @IBAction func pickimage(sender: AnyObject) {
        let imagepick = UIImagePickerController()
        imagepick.delegate = self
        imagepick.sourceType = .PhotoLibrary
        self.presentViewController(imagepick, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profileimage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

