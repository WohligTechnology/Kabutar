//
//  NoteModel.swift
//  deploynotshare
//
//  Created by Chintan Shah on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import Foundation
import SQLiteCipher

import SwiftHTTP
import SwiftyJSON

public class Note {
    
    
    public let db = AppDelegate.getDatabase()
    public let note = Table("note")
    public let id = Expression<Int64>("id")
    public let title = Expression<String?>("title")
    public let creationTime = Expression<Int64>("creationTime")
    public let modificationTime = Expression<Int64>("modificationTime")
    
    public let background = Expression<String?>("background")
    public let color = Expression<String?>("color")
    public let folder = Expression<Int64>("folder")
    public let islocked = Expression<Int64>("islocked")
    public let paper = Expression<String?>("paper")
    public let reminderTime = Expression<Int64>("reminderTime")
    public let serverid = Expression<String?>("serverid")
    public let tags = Expression<String?>("tags")
    public let timebomb = Expression<Int64>("timebomb")
    public var noteElement = NoteElement();
    
    init() {
        try! db.run(note.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(title)
            t.column(creationTime)
            t.column(modificationTime)
            t.column(background)
            t.column(color)
            t.column(folder)
            t.column(islocked)
            t.column(paper)
            t.column(reminderTime)
            t.column(serverid)
            t.column(tags)
            t.column(timebomb)
            })
    }
    
    func create(title2:String,background2:String,color2:String,folder2:Int64,islocked2:Int64,paper2:String,reminderTime2:Int64,serverid2:String,tags2:String,timebomb2:Int64) {
        let date = NSDate().timeIntervalSince1970
        let insert = note.insert( title <- title2, creationTime <- Int64(date), modificationTime <- Int64(date), background <- background2, color <- color2, folder <- folder2, islocked <- islocked2,paper <- paper2 , reminderTime <- reminderTime2, serverid <- serverid2, tags <- tags2 , timebomb <- timebomb2)
        
       
        
        try! db.run(insert)
    }
    
    func findOne(id2:Int64) -> Row?  {
        
        let newval =  db.pluck(note.filter(id == id2) )
        return newval
        
    }
    
    func find(txt:String) -> AnySequence<Row>  {
        let date = NSDate().timeIntervalSince1970
        let date2 = Int64(date)
        let returnArr:AnySequence<Row>!
        let sortwith = config.get("note_sort");
        switch (sortwith) {
            case "1":
            returnArr = db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0) && title.like("%"+txt+"%") ).order(title.lowercaseString) )
            case "2":
            returnArr = db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0) && title.like("%"+txt+"%") ).order(color, id.desc ,title.lowercaseString) )
            case "3":
            returnArr = db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0) && title.like("%"+txt+"%") ).order(id.desc ,title.lowercaseString) )
            case "4":
            returnArr = db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0) && title.like("%"+txt+"%") ).order(modificationTime.desc,title.lowercaseString) )
            case "5":
            returnArr = db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0) && title.like("%"+txt+"%") ).order(reminderTime.desc,title.lowercaseString) )
            case "6":
            returnArr = db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0) && title.like("%"+txt+"%") ).order(timebomb.desc ,title.lowercaseString) )
            default:
            returnArr = db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0) && title.like("%"+txt+"%") ).order(id.desc ,title.lowercaseString) )
        }
        return returnArr
        
    }
    
    func find2 (txt:String) -> Statement {
        
        self.localtoserver()
        
        let date = NSDate().timeIntervalSince1970
        let date2 = String(Int64(date))
        var folderWhere = "";
        if(selectedFolderToNoteId !=  "")
        {
            folderWhere  = " `note`.`folder` =  '\(selectedFolderToNoteId)' AND ";
        }
        
        let sortwith = config.get("note_sort");
        var sortwithText = ""
        switch (sortwith) {
        case "1":
            sortwithText = " LOWER(`note`.`title`) "
        case "2":
             sortwithText = "`note`.`color`,`note`.`id` DESC ,LOWER(`note`.`title`) "
            
        case "3":
            sortwithText = "`note`.`id` DESC ,LOWER(`note`.`title`) "
        case "4":
            sortwithText = "`note`.`modificationTime`,`note`.`id` DESC ,LOWER(`note`.`title`) "
           
        case "5":
            sortwithText = "`note`.`reminderTime`,`note`.`id` DESC ,LOWER(`note`.`title`) "
        case "6":
            sortwithText = "`note`.`timebomb` DESC ,`note`.`id` DESC ,LOWER(`note`.`title`) "
            
        default:
            sortwithText = "`note`.`id` DESC ,LOWER(`note`.`title`) "
        }
        
        let returnArr = db.prepare("SELECT `note`.`id`, `note`.`title`,`note`.`color`,`note`.`islocked`,GROUP_CONCAT(`NoteElement`.`contentA`,' '),`note`.`modificationTime` FROM `note` LEFT OUTER JOIN `NoteElement` ON `note`.`id` = `NoteElement`.`noteid` AND `NoteElement`.`contentA` != '' AND `NoteElement`.`type` = 'text'  WHERE \(folderWhere) `note`.`creationTime` != 0 AND  (`note`.`timebomb` = 0 OR  `note`.`timebomb` > \(date2)) AND ( `note`.`title` LIKE '%\(txt)%' OR `NoteElement`.`contentA` LIKE '%\(txt)%' )  GROUP BY `note`.`id` ORDER BY \(sortwithText)")
        return returnArr
    }
    
    func edit(title2:String,background2:String,color2:String,folder2:Int64,islocked2:Int64,paper2:String,reminderTime2:Int64,serverid2:String,tags2:String,timebomb2:Int64,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(title <- title2, creationTime <- Int64(date), modificationTime <- Int64(date), background <- background2, color <- color2, folder <- folder2, islocked <- islocked2,paper <- paper2 , reminderTime <- reminderTime2, serverid <- serverid2, tags <- tags2 , timebomb <- timebomb2))
    }
    
    func changeModificationDate(id2: Int64) {
        let date = NSDate().timeIntervalSince1970
        let note2 = note.filter(id == id2)
        try! db.run(note2.update(modificationTime <- Int64(date)))
    }
    
    func delete(id2:String) {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(title <- "", creationTime <- 0, modificationTime <- Int64(date), background <- "", color <- "", folder <- 0, islocked <- 0,paper <- "" , reminderTime <- 0, tags <- "" , timebomb <- 0))
    }
    
    func getNotesFolder(folder2:String) -> AnySequence<Row>  {
        let date = NSDate().timeIntervalSince1970
        let date2 = Int64(date)
        return try! db.prepare(note.filter(creationTime != 0 && (timebomb > date2 ||  timebomb == 0)  &&  folder == strtoll(folder2,nil,10) ).order(id.desc,title) )
    }
    
    func changeNoteFolder(folder2:String,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(folder <- strtoll(folder2,nil,10),modificationTime <- Int64(date)))
    }
    
    func changeTimeBomb(timebomb2:Int64,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(timebomb <- timebomb2,modificationTime <- Int64(date)))
    }
    
    func changeLock(islocked2:Int64,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(islocked <- islocked2,modificationTime <- Int64(date)))
    }

    func changeReminderTime(reminderTime2:Int64,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(reminderTime <- reminderTime2,modificationTime <- Int64(date)))
    }
    
    func changeColor(color2:String,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(color <- color2,modificationTime <- Int64(date)))
    }
    
    func changeTitle(title2:String,id2:String) {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(title <- title2,modificationTime <- Int64(date)))
    }

    func syncSave(serverID2: String,creationTime2:String,modificationTime2:String,order2: String,name2: String) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let creationTime3 = dateFormatter.dateFromString(creationTime2)
        let modificationTime3 = dateFormatter.dateFromString(modificationTime2)
        let creationTime4 = Int64((creationTime3?.timeIntervalSince1970)! )
        let modificationTime4 = Int64((modificationTime3?.timeIntervalSince1970)!)
        let order3 = strtoll(order2,nil,10)
        
        let count = try db.scalar(note.filter(serverid == serverID2).count)
        if(count > 0)
        {
            let fol2 = note.filter(serverid == serverID2 && modificationTime < modificationTime4  )
            try! db.run(fol2.update(title <- name2, modificationTime <- modificationTime4 ) )
        }
        else
        {
            let insert = note.insert( title <- name2, creationTime <- creationTime4, modificationTime <- modificationTime4,  serverid <- serverID2)
            try! db.run(insert)
        }
        
    }
    
    func setServerId(serverid2:String,id2:String) {
        let id3 = strtoll(id2,nil,10)
        let fol = note.filter(id == id3)
        try! db.run(fol.update(serverid <- serverid2))
    }
    
    func deleteServer(serverID2: String) {
        let fol = note.filter(serverid == serverID2)
        try! db.run(fol.delete())
    }
    
    func servertolocal() {
        
        let ServerDateFormatter = NSDateFormatter()
        ServerDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var ServerToLocal = ServerDateFormatter.stringFromDate(NSDate( timeIntervalSince1970: NSTimeInterval( strtoll(config.get("folder_server_to_local"),nil,10) ) ))
        
        
        if(ServerToLocal == "")
        {
            ServerToLocal = "1970-01-01 00:00:00";
        }
        let params = ["modifytime": ServerToLocal,
            "user":config.get("user_id")]
        
        print(params)
//        do  {
//            let opt = try request.POST(ServerURL+"folder/servertolocal", parameters: params)
//            opt.start { response in
//                let json = JSON(data: response.data)
//                
//                print(json);
//                for (key,subJson):(String, JSON) in json {
//                    //Do something you want
//                    
//                    print(key)
//                    print(subJson)
//                    
//                    if(subJson["folderid"] != nil)
//                    {
//                        print("Inside 1");
//                        if(subJson["creationtime"].string == "")
//                        {
//                            self.deleteServer(subJson["folderid"].string!)
//                        }
//                        else {
//                            print("Inside 2")
//                            self.syncSave(subJson["folderid"].string!, creationTime2: subJson["creationtime"].string!, modificationTime2: subJson["modifytime"].string!, order2: subJson["order"].string!, name2: subJson["name"].string!)
//                        }
//                        
//                        // change modify time to server
//                        let dateFormatter = NSDateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//                        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//                        let modval = dateFormatter.dateFromString(subJson["modifytime"].string!)! as NSDate
//                        
//                        config.set("folder_server_to_local", value2: String(modval.timeIntervalSince1970))
//                    }
//                    
//                    
//                }
//                
//                self.localtoserver()
//            }
//            
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }
        
        
    }
    
    func getNoteStatementToSync() -> Statement {
        let lastLocaltoServer = strtoll(config.get("note_local_to_server"),nil,10)
        
        
        print(lastLocaltoServer)
        print("SELECT * FROM (SELECT `note`.`id`,`note`.`title`,`note`.`creationTime`,`note`.`modificationTime`,`note`.`background`,`color`, `folder`.`id` as `folder` ,`note`.`islocked`,`note`.`paper`,`note`.`reminderTime`,`note`.`serverid`,`note`.`tags`,`note`.`timebomb` FROM `note` LEFT OUTER JOIN `folder` ON `folder`.`id` =  `note`.`folder` ORDER BY `note`.`modificationTime` ASC) WHERE `modificationTime` > \(lastLocaltoServer) ")
        let query = db.prepare("SELECT * FROM (SELECT `note`.`id`,`note`.`title`,`note`.`creationTime`,`note`.`modificationTime`,`note`.`background`,`color`, `folder`.`id` as `folder` ,`note`.`islocked`,`note`.`paper`,`note`.`reminderTime`,`note`.`serverid`,`note`.`tags`,`note`.`timebomb` FROM `note` LEFT OUTER JOIN `folder` ON `folder`.`id` =  `note`.`folder` ORDER BY `note`.`modificationTime` ASC) WHERE `modificationTime` > \(lastLocaltoServer) ")
        return query
    }
    
    func localtoserver() {
        
        let rows = getNoteStatementToSync()
        for row in rows {
            let ServerDateFormatter = NSDateFormatter()
            ServerDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //ServerDateFormatter.dateStyle = .FullStyle
            //ServerDateFormatter.timeStyle = .FullStyle
            //ServerDateFormatter.timeZone = NSTimeZone(name: "UTC")
            
            let rowid = String(row[0] as! Int64!)
            
            
            let ElementRows = noteElement.getAllNoteElement( strtoll(rowid,nil,10) );
            
            
            
            var jsonNoteElement = " [ "
            
            var i=0
            
            for row in ElementRows
            {
                
                if(i == 0)
                {
                    
                }
                else
                {
                        jsonNoteElement += ","
                }
                i++
                
                jsonNoteElement += "{ \"id\": \"\(row[noteElement.id])\" , \"content\" : \"\(row[noteElement.content]!)\" , \"contentA\": \"\(row[noteElement.contentA]!)\" , \"contentB\": \"\(row[noteElement.contentB]!)\" , \"type\": \"\(row[noteElement.type]!)\", \"order\": \"\(row[noteElement.order]!)\"  }"
                
            }
            
            let index1 = jsonNoteElement.endIndex.advancedBy(-2)
            
            var substring1 = jsonNoteElement.substringToIndex(index1)
            
            jsonNoteElement += " ] "
            
            let creationDate2 =  NSDate(timeIntervalSince1970: NSTimeInterval(row[2] as! Int64!))
            var creationDateStr = ServerDateFormatter.stringFromDate(creationDate2)
            let checkcreation = row[2] as! Int64!
            print(checkcreation)
            if(checkcreation == 0)
            {
                creationDateStr = "0"
            }
            let mofificationDate2  = NSDate(timeIntervalSince1970: NSTimeInterval(row[3] as! Int64!))
            
            
            
            var folder2 = row[6] as! String!
            if(folder2 == nil)
            {
                folder2 = ""
            }
            
            
            
            let params : Dictionary<String,AnyObject>  = ["title":row[1] as! String!,
                "creationtime":  creationDateStr ,
                "modifytime": ServerDateFormatter.stringFromDate(mofificationDate2) ,
                "user":config.get("user_id"),
                "_id":row[10] as! String!,
                "background": row[4] as! String!,
                "color": row[5] as! String!,
                "folder": folder2,
                "islocked": String(row[7] as! Int64!),
                "paper": row[8] as! String!,
                "remindertime": String(row[9] as! Int64!),
                "tags": row[11] as! String!,
                "timebomb": String(row[12] as! Int64!),
                "noteelements" : jsonNoteElement,
            ]
            print(params);
            print("GOINT INSIDE");
            
            request.POST(ServerURL+"note/localtoserver", parameters: params, completionHandler: {(response: HTTPResponse) in
                
                let json = JSON(data: response.responseObject as! NSData)
                print(json);
                
                config.set("note_local_to_server",value2: String(row[3] as! Int64!))
                
                if(json["id"].string != nil)
                {
                    self.setServerId(json["id"].string!,id2:rowid)
                    
                    if(creationDateStr == "0")
                    {
                        self.delete(rowid)
                    }
                }
            })
        }
    }
}