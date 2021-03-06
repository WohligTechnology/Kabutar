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
import Google
import LocalAuthentication
import SwiftHTTP
import SwiftyJSON


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FBSDKLoginButtonDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var facebookButtomImage: UIButton!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var nametext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let authenticationContext = LAContext()
//        
//        var error:NSError?
//        
//        // 2. Check if the device has a fingerprint sensor
//        // If not, show the user an alert view and bail out!
//        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
//            
//            print("NO thing available");
//            return
//        }
//        
//        authenticationContext.evaluatePolicy(
//            .DeviceOwnerAuthenticationWithBiometrics,
//            localizedReason: "Only awesome people are allowed",
//            reply: { [unowned self] (success, error) -> Void in
//                
//                if( success ) {
//                    
//                    print("Success");
//                    
//                }else {
//                    
//                    // Check if there is an error
//                    if let error = error {
//                        
//                        print("message is error");
//                        
//                    }
//                    
//                }
//                
//            })
        
        
        
        
                
        GIDSignIn.sharedInstance().uiDelegate = self

        
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
    
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
        presentViewController viewController: UIViewController!) {
            self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
        dismissViewController viewController: UIViewController!) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        
        
        if result?.token?.tokenString != nil
        {
            
            
            request.GET("https://graph.facebook.com/v2.5/me?"+"fields=id,name,email,picture&access_token=\(result.token.tokenString)", parameters: nil, completionHandler: {(response: HTTPResponse) in
            
                let json = JSON(data: response.responseObject as! NSData)
                
                config.set("user_name",value2: json["name"].string!);
                config.set("user_email",value2: json["email"].string!);
                config.set("user_facebook_id",value2: json["id"].string!);
                config.set("sync_via",value2: "2");

                
                request.GET("https://graph.facebook.com/v2.5/me/picture?redirect=0&me/picture?redirect=0&height=1000&width=1000&access_token=\(result.token.tokenString)", parameters: nil, completionHandler: {(response: HTTPResponse) in
                    
                    let json2 = JSON(data: response.responseObject as! NSData)
                
                    print(json2);
                    
                    config.set("user_pic_url",value2: json2["data"]["url"].string!);
                
                
                    if let url = NSURL(string: json2["data"]["url"].string!) {
                    if let data = NSData(contentsOfURL: url) {
                        
                        let image = UIImage(data: data)
                        
                        let imagename = "profile.jpg"
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                        let destinationPath = String(documentsPath) + "/" + imagename
                        
                        UIImageJPEGRepresentation(image!,1.0)!.writeToFile(destinationPath, atomically: true)
                        
                        config.set("user_pic",value2: imagename);
                        
                        
                        
                        
                        let params: Dictionary<String,AnyObject>  = ["email": config.get("user_email"), "fbid": config.get("user_facebook_id"), "googleid": config.get("user_google_id"),"profilepic":config.get("user_pic_url"),"name":config.get("user_name")]
                        
                        request.POST(ServerURL+"user/sociallogin", parameters: params, completionHandler: {(response: HTTPResponse) in
                            
                            let json = JSON(data: response.responseObject as! NSData)
                            config.set("user_id", value2: json["_id"].string!)
                            let seconds = 0.2
                            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            
                            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                                self.changeView()
                                
                            })
                            
                        })
                    }
                }

                })
                
            })
            
           
            
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

