//
//  NotificationModel.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 10/03/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//


import Foundation
import SQLiteCipher
import SwiftHTTP
import SwiftyJSON

public class Notification {
    func getNotification(completion : ((JSON)->Void)) {
        let params = ["user":config.get("user_id")];
        var json : JSON!
        do{
        request.POST(ServerURL+"notification/find", parameters: params, completionHandler: {(response: HTTPResponse) in
            
            
           try!  json = JSON(data: response.responseObject as! NSData)
//           print(json)
            completion(json)
        })
        }
        catch{
            completion(1)
        }
    }
}

