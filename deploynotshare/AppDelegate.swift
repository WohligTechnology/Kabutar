//
//  AppDelegate.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 21/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import SQLiteCipher
import UIColor_Hex_Swift
import Google
import FBSDKCoreKit


import SwiftHTTP
import SwiftyJSON

var ViewForNotes:Any!
//var maincnt  = ViewForNotes


//let mainview = ViewForNotes as! UIViewController

//var ServerURL = "http://api.noteshareapp.com/"
var ShareServerURL = "http://www.noteshareapp.com/"
//var ServerURL = "http://"
var ServerURL = "http://192.168.1.122:83/"
var GAppDelegate:AppDelegate!
var MainWidth:CGFloat!
var MainHeight:CGFloat!
var SelectedNoteColor = ""
var ColorNote = String()
let config = Config()
var NoteElementModel = NoteElement()
var selectedNoteId = ""
var selectedNoteDesc = ""
var selectedName = ""
var selectedNote = ""
var selectedNoteIndex = Int()
var datetimepopupType = ""
let bounds = UIScreen.mainScreen().bounds
let width = bounds.size.width
let height = bounds.size.height
var innotepage = 0;
var isScreenShot = 0
var isloadfirst = true
var noteid = ""

public var noteModel  = Note()

var request = HTTPTask()

let PinkColor = UIColor(rgba: "#FF5A60")
let DefaultColor = UIColor(red: 255.0/255.0, green: 255.0/255, blue: 255.0/255, alpha: 1.0)

let NoteColors = [
    "#96CEEE",
    "#FAE8CE",
    "#97E1CC",
    "#FDFF7F",
    "#9FDB86",
    "#BE9FF6",
    "#B6E29E",
    "#DCA9AA",
    "#F0A6EF",
    "#D0D0D0",
    "#EEEEEE",
    "#FFFFFF"
]

let ConfigObj = Config()
var path:String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
var onlyOnce = true
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    static func getDatabase () -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        let db = try! Connection("\(path)/db.sqlite3")
        if(onlyOnce)
        {
            onlyOnce = false;
            print(path);
        }
        return db;
    }

    
    public func createMenuView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let noteView = config.get("note_view")
        var nvc: UINavigationController!
        
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("MenuListViewController") as! MenuListViewController
        switch (noteView)
        {
        case "1":
            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("Detailview") as! Detailview
            nvc = UINavigationController(rootViewController: mainViewController)
            
        case "2":
            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("Listview") as! Listview
            nvc = UINavigationController(rootViewController: mainViewController)
            
        case "3":
            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("cardViewController") as! cardViewController
            nvc = UINavigationController(rootViewController: mainViewController)
            
        default:
            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("Detailview") as! Detailview
            nvc = UINavigationController(rootViewController: mainViewController)
            
        }
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UILabel.appearance().font = UIFont(name: "Agenda", size: 14)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Agenda", size: 16)!,NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        GAppDelegate = self
        // Override point for customization after application launch.
      
        let bounds = UIScreen.mainScreen().bounds
        MainWidth = bounds.size.width
        MainHeight = bounds.size.height

        AppDelegate.getDatabase()
        
        
        //self.createMenuView()
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return GIDSignIn.sharedInstance().handleURL(url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            dispatch_async(dispatch_get_main_queue(),{

            if (error == nil || user != nil) {
                print("in if")
                // Perform any operations on signed in user here.
                print("device id before")
                print(UIDevice.currentDevice().identifierForVendor!.UUIDString)
                let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
                config.set("user_device_id",value2: deviceId)
                print("device id after")
                let userId = user.userID                  // For client-side use only!
                let idToken = user.authentication.idToken // Safe to send to the server
                let name = user.profile.name
                let email = user.profile.email
                let imageurl = user.profile.imageURLWithDimension(100)

                
                var imageurlStr = "http://www.wohlig.com/";
                try! imageurlStr = String(imageurl)
                
                config.set("user_name",value2: name);
                config.set("user_email",value2: email);
                config.set("user_google_id",value2: userId);
                try! config.set("user_pic_url",value2: imageurlStr);
                
                
                if let url = imageurl {
                    if let data = NSData(contentsOfURL: url) {
                        
                        let image = UIImage(data: data)
                        
                        let imagename = "profile.jpg"
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                        let destinationPath = String(documentsPath) + "/" + imagename
                        
                        UIImageJPEGRepresentation(image!,1.0)!.writeToFile(destinationPath, atomically: true)
                        
                        config.set("user_pic",value2: imagename);
                        
                        let params: Dictionary<String,AnyObject>= ["email": user.profile.email, "fbid": config.get("user_facebook_id"), "googleid": user.userID,"profilepic":user.profile.imageURLWithDimension(100),"name":user.profile.name,"deviceid":deviceId]
                        print(params)
                        
                        request.POST(ServerURL+"user/sociallogin", parameters: params, completionHandler: {(response: HTTPResponse) in
                            
                                print("device id before")
                                print(UIDevice.currentDevice().identifierForVendor!.UUIDString)
                                print("device id after")
                            
                                let json = JSON(data: response.responseObject as! NSData)
                                print("social login response;")
                                print(json);
                                config.set("user_id", value2: json["_id"].stringValue)
                                
                                let seconds = 0.2
                                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                
                                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                                    self.createMenuView()
                                    
//                                    noteModel.localtoserver{(json: JSON) -> () in
//                                                    noteModel.servertolocal{(json: JSON) -> () in
//                                                        
//                                                    }
//                                                    }
                                    
                                })
                            
//
                        
                        })
                    }
                }
                
            } else {
                print("In else")
                print("\(error.localizedDescription)")
            }
                
            })
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        
        let seconds = transitionTime
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        
        
        
        
        
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let folderViewController = storyboard.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
            let folderViewController2 = UINavigationController(rootViewController: folderViewController)
            
            let SettingView = storyboard.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
            let SettingView2 = UINavigationController(rootViewController: SettingView)
            
            let sideMenuController  = slideMenuLeft as! SlideMenuController
            
            switch(shortcutItem.type)
            {
            case "setting":
                print("Setting");
                
                sideMenuController.changeMainViewController(SettingView2, close: true)
                
            case "folder":
                
                isInsideFolder = 1
                sideMenuController.changeMainViewController(folderViewController2, close: true)
                
            case "createNote":
                
                let checkstatus = config.get("note_view");
                let notesobj = Note()
                let noteid = notesobj.createnoname("",background2: "background",color2: "10", folder2: 0, islocked2: 0,paper2: "",reminderTime2: 0,serverid2: "",tags2: "",timebomb2: 0)
                
                
                
                if(checkstatus == "2"){
                    let mainview = ViewForNotes as! Listview
                    mainview.getAllNotes()
                    mainview.listView!.reloadData()
                    mainview.getselectedNote(noteid)
                    mainview.performSegueWithIdentifier("showdetaillistview", sender: self)
                }else if(checkstatus == "1"){
                    let mainview = ViewForNotes as! Detailview
                    mainview.getAllNotes()
                    mainview.detailtableview!.reloadData()
                    mainview.getselectedNote(noteid)
                    mainview.performSegueWithIdentifier("showdetaildetailview", sender: self)
                }else if(checkstatus == "3"){
                    let mainview = ViewForNotes as! cardViewController
                    mainview.getAllNotes()
                    mainview.collectionView!.reloadData()
                    mainview.getselectedNote(noteid)
                    mainview.performSegueWithIdentifier("showdetail", sender: self)
                }
                else if(checkstatus == ""){
                    let mainview = ViewForNotes as! Detailview
                    mainview.getAllNotes()
                    mainview.detailtableview!.reloadData()
                    mainview.getselectedNote(noteid)
                    mainview.performSegueWithIdentifier("showdetaildetailview", sender: self)
                }
                
            default:
                break;
            }
            
        })
        
    }


}