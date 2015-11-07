//
//  AppDelegate.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 21/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import SQLiteCipher

var ViewForNotes:Any!
var checkstatus = 3 as Int64

var MainWidth:CGFloat!
var MainHeight:CGFloat!

let PinkColor = UIColor(red: 255.0/255.0, green: 90/255, blue: 96/255, alpha: 1.0)

let NoteColors = [
    UIColor(rgba:"#96CEEE"),
    UIColor(rgba: "#FAE8CE"),
    UIColor(rgba: "#97E1CC"),
    
    UIColor(rgba: "#FDFF7F"),
    UIColor(rgba: "#9FDB86"),
    UIColor(rgba: "#BE9FF6"),
    
    UIColor(rgba: "#B6E29E"),
    UIColor(rgba: "#DCA9AA"),
    UIColor(rgba: "#F0A6EF"),
    UIColor(rgba: "#D0D0D0")
]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static func CheckThis() {
        print("This is just to check")
    }
    
    static func getDatabase () -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        print(path);
        let db = try! Connection("\(path)/db.sqlite3")
        
        return db;
    }

    
    private func createMenuView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("cardViewController") as! cardViewController
//        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("MenuView") as! MenuView
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("MenuListViewController") as! MenuListViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        
        
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.createMenuView()
        let bounds = UIScreen.mainScreen().bounds
        MainWidth = bounds.size.width
        MainHeight = bounds.size.height

        
        
        AppDelegate.getDatabase()
        return true
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

