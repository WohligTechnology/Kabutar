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


import SwiftHTTP
import SwiftyJSON


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var facebookButtomImage: UIButton!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var nametext: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(config.get("user_id") != "")
        {
            self.changeView()
        }
        
        
        
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in..")
        }
        else
        {
            print("Logged in..")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        self.facebookView.addSubview(loginButton)
        loginButton.frame = CGRectMake(0, 0, facebookView.frame.width+55, facebookView.frame.height)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        
        
        if result?.token?.tokenString != nil
        {
            print("CHINTANNNNNAmdfhdjkfhkdfdjfhkdjf");
             print(result?.token?.tokenString);
            do {
                let opt = try! HTTP.GET("https://graph.facebook.com/v2.5/me?"+"fields=id,name,email,picture&access_token=\(result.token.tokenString)")
                opt.start { response in
                    let json = JSON(data: response.data)
                    print(json);
                    config.set("user_name",value2: json["name"].string!);
                    config.set("user_email",value2: json["email"].string!);
                    config.set("user_facebook_id",value2: json["id"].string!);
                    config.set("user_id_name",value2: json["id"].string!);
                    config.set("user_pic_url",value2: json["picture"]["data"]["url"].string!);
                    
                    
                    if let url = NSURL(string: json["picture"]["data"]["url"].string!) {
                        if let data = NSData(contentsOfURL: url) {
                            
                            let image = UIImage(data: data)
                            
                            let imagename = "profile.jpg"
                            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                            let destinationPath = String(documentsPath) + "/" + imagename
                            
                            UIImageJPEGRepresentation(image!,1.0)!.writeToFile(destinationPath, atomically: true)
                            
                            config.set("user_pic",value2: imagename);
                            
                            
                            
                            
                            let params = ["email": config.get("user_email"), "fbid": config.get("user_facebook_id"), "googleid": config.get("user_google_id"),"profilepic":config.get("user_pic_url"),"name":config.get("user_name")]
                            do {
                                let opt = try HTTP.POST(ServerURL+"user/sociallogin", parameters: params)
                                opt.start { response in
                                    let json = JSON(data: response.data)
                                    config.set("user_id", value2: json["_id"].string!)
                                    
                                    let seconds = 0.2
                                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                    
                                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                                      self.changeView()
                                        
                                    })
                                    
                                }
                            
                            } catch let error {
                                print("got an error creating the request: \(error)")
                            }
                            
                            
                        }
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
           
            
        }
        else
        {
            //print(error.localizedDescription)
        }
    }
    
    func changeView() {
        let appDelegate = UIApplication.sharedApplication().delegate
            as? AppDelegate
        appDelegate?.createMenuView()
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

