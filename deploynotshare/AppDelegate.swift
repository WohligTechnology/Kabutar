//
//  AppDelegate.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 21/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import SQLiteCipher
import SwiftyJSON
import UIColor_Hex_Swift

import FBSDKCoreKit

var ViewForNotes:Any!


var ServerURL = "http://104.197.122.116/"
var GAppDelegate:AppDelegate!
var MainWidth:CGFloat!
var MainHeight:CGFloat!
var SelectedNoteColor = UIColor()
var ColorNote = String()
let config = Config()
var NoteElementModel = NoteElement()
var selectedNoteId = ""
var selectedNoteIndex = Int()

let bounds = UIScreen.mainScreen().bounds
let width = bounds.size.width
let height = bounds.size.height

let PinkColor = UIColor(red: 255.0/255.0, green: 90/255, blue: 96/255, alpha: 1.0)
let DefaultColor = UIColor(red: 255.0/255.0, green: 255.0/255, blue: 255.0/255, alpha: 1.0)

let NoteColors = [
    UIColor(rgba: "#96CEEE"),
    UIColor(rgba: "#FAE8CE"),
    UIColor(rgba: "#97E1CC"),
    UIColor(rgba: "#FDFF7F"),
    UIColor(rgba: "#9FDB86"),
    UIColor(rgba: "#BE9FF6"),
    UIColor(rgba: "#B6E29E"),
    UIColor(rgba: "#DCA9AA"),
    UIColor(rgba: "#F0A6EF"),
    UIColor(rgba: "#D0D0D0"),
    UIColor(rgba: "#EEEEEE")
]
let ConfigObj = Config()
var path:String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static func getDatabase () -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        let db = try! Connection("\(path)/db.sqlite3")
        print(path);
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
        GAppDelegate = self
        // Override point for customization after application launch.
      
        let bounds = UIScreen.mainScreen().bounds
        MainWidth = bounds.size.width
        MainHeight = bounds.size.height

        AppDelegate.getDatabase()
        self.createMenuView()
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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


}

