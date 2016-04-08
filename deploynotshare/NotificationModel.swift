//
//  NotificationModel.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 10/03/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//


import Foundation

import SwiftHTTP
import SwiftyJSON

public class Notification {
    func getNotification(completion : ((JSON)->Void)) {
        print(config.get("user_id"))
        let params = ["user":config.get("user_id")];
        var json : JSON!
        do{
        request.POST(ServerURL+"notification/find", parameters: params, completionHandler: {(response: HTTPResponse) in
            
            
           try!  json = JSON(data: response.responseObject as! NSData)
            completion(json)
        })
        }
        catch{
            completion(1)
        }
    }
    func notificationStatus(note:String, folder:String, userid:String, status:String, completion:((JSON)->Void)){
       
        let params = ["user":config.get("user_id"), "note":note, "folder":folder, "userid":userid, "status":status];
        var json : JSON!
        do{
            request.POST(ServerURL+"notification/noteStatus", parameters: params, completionHandler: {(response: HTTPResponse) in
                try! json = JSON(data: response.responseObject as! NSData)
                completion(json)
            })
        }
        catch{
            completion(1)
        }
    }
    func notificationCount(completion:((JSON)->Void)){
        
        let params = ["user":config.get("user_id")];
        var json : JSON!
        do{
            request.POST(ServerURL+"notification/countNoti", parameters: params, completionHandler: {(response: HTTPResponse) in
                try! json = JSON(data: response.responseObject as! NSData)
                completion(json)
            })
        }
        catch{
            completion(1)
        }
    }
//    func sendFeedback(user:String, text:String, completion: ((JSON)->Void)) {
//        let params = ["user":user, "text":text];
//        var json : JSON!
//        do{
//            request.POST(<#T##url: String##String#>, parameters: <#T##Dictionary<String, AnyObject>?#>, completionHandler: <#T##((HTTPResponse) -> Void)!##((HTTPResponse) -> Void)!##(HTTPResponse) -> Void#>)
//        }
//    }

}

