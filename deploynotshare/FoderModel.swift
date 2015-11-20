//
//  FoderModel.swift
//  deploynotshare
//
//  Created by Chintan Shah on 31/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import Foundation
import SQLiteCipher
import SwiftHTTP
import SwiftyJSON

public class Folder {
    
    
    public let db = AppDelegate.getDatabase()
    public let folder = Table("folder")
    public let id = Expression<Int64>("id")
    public let name = Expression<String?>("name")
    public let creationTime = Expression<Int64>("creationTime")
    public let modificationTime = Expression<Int64>("modificationTime")
    public let order = Expression<Int64>("order")
    public let serverID = Expression<String>("serverid")
    
    init() {
        
        try! db.run(folder.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(name)
            t.column(creationTime)
            t.column(modificationTime)
            t.column(order)
            t.column(serverID)
            })
        
    }
    
    func create(name2:String) -> AnySequence<Row>  {
        let date = NSDate().timeIntervalSince1970
        let insert = folder.insert( name <- name2, creationTime <- Int64(date), modificationTime <- Int64(date), order <- 1, serverID <- "")
        try! db.run(insert)
        return try! db.prepare(folder)
    }
    
    func find() -> AnySequence<Row>  {
        return try! db.prepare(folder.filter(creationTime != 0).order(id.desc))
    }
    
    func edit(name2:String,id2:String) -> AnySequence<Row>  {
        let date = NSDate().timeIntervalSince1970

        let id3 = strtoll(id2,nil,10)
        let fol = folder.filter(id == id3)
        try! db.run(fol.update(name <- name2, modificationTime <- Int64(date)))
        return try! db.prepare(folder)
    }
    
    func setServerId(serverid2:String,id2:String) {
        let id3 = strtoll(id2,nil,10)
        let fol = folder.filter(id == id3)
        try! db.run(fol.update(serverID <- serverid2))
    }

    func delete(id2:String) -> AnySequence<Row>  {
        let date = NSDate().timeIntervalSince1970

        let id3 = strtoll(id2,nil,10)
        let fol = folder.filter(id == id3)
        try! db.run(fol.update(name <- "", modificationTime <- Int64(date), creationTime <- 0))
        return try! db.prepare(folder)
    }
    
    func getFolderStatementToSync() -> Statement {
        let lastLocaltoServer = strtoll(config.get("folder_local_to_server"),nil,10)
        let query = db.prepare("SELECT * FROM (SELECT * FROM `folder` ORDER BY `folder`.`modificationTime` ASC) WHERE `modificationTime` > \(lastLocaltoServer) ")
        return query
    }
    
    func localtoserver() {
        
        let rows = getFolderStatementToSync()
        for row in rows {
            let ServerDateFormatter = NSDateFormatter()
            ServerDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //ServerDateFormatter.dateStyle = .FullStyle
            //ServerDateFormatter.timeStyle = .FullStyle
            //ServerDateFormatter.timeZone = NSTimeZone(name: "UTC")

            
            let rowid = String(row[0] as! Int64!)
            let creationDate2 =  NSDate(timeIntervalSince1970: NSTimeInterval(row[2] as! Int64!))
            var creationDateStr = ServerDateFormatter.stringFromDate(creationDate2)
            let checkcreation = row[2] as! Int64!
            print(checkcreation)
            if(checkcreation == 0)
            {
                creationDateStr = "0"
            }
            let mofificationDate2  = NSDate(timeIntervalSince1970: NSTimeInterval(row[3] as! Int64!))
            
            
            
            let params = ["name":row[1] as! String!,
                "creationtime":  creationDateStr ,
                "modifytime": ServerDateFormatter.stringFromDate(mofificationDate2) ,
                "order":String(row[4] as! Int64!),
                "user":config.get("user_id"),
                "_id":row[5] as! String! ]
            
            print(params)
            do  {
                let opt = try HTTP.POST(ServerURL+"folder/localtoserver", parameters: params)
                opt.start { response in
                    let json = JSON(data: response.data)
                    
                    config.set("folder_local_to_server",value2: String(row[3] as! Int64!))
                    print(json);
                    if(json["id"].string != nil)
                    {
                        self.setServerId(json["id"].string!,id2:rowid)
                    }
                }
                
            } catch let error {
                print("got an error creating the request: \(error)")
            }

            
        }
        
        
    }
    
    
}