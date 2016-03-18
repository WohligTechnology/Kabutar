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
import SystemConfiguration

public class Note {
    
    func getImage(urlStr:String) -> UIImage {
        let url = NSURL(string: urlStr)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        return UIImage(data: data!)!
    }
    
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
    
    func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }

    func shareNote(note:String,email:String,completion : ((JSON)->Void)) {
        let params = ["userfrom":config.get("user_id"),"note":note,"email":email];
        var json : JSON!
        do {
            request.POST(ServerURL+"share/save", parameters: params, completionHandler: {(response: HTTPResponse) in
                
                
                try!  json = JSON(data: response.responseObject as! NSData)
                completion(json)
            })
        }
        catch {
            completion(1)
        }
    }
    
    func createnoname(title2:String,background2:String,color2:String,folder2:Int64,islocked2:Int64,paper2:String,reminderTime2:Int64,serverid2:String,tags2:String,timebomb2:Int64) -> Int64 {
        let date = NSDate().timeIntervalSince1970
        let insert = note.insert( title <- title2, creationTime <- Int64(date), modificationTime <- Int64(date), background <- background2, color <- color2, folder <- folder2, islocked <- islocked2,paper <- paper2 , reminderTime <- reminderTime2, serverid <- serverid2, tags <- tags2 , timebomb <- timebomb2)
        var val = try! db.run(insert)
        let onlyid  = val;
        
        let newid = db.prepare("SELECT IFNULL(MAX(CAST(SUBSTR(`title`,5) AS UNSIGNED))+1,1) as `num` FROM `note` WHERE `title` LIKE 'Note %' AND `creationTime` > 0  AND (`timebomb` > \(date) OR `timebomb` = 0) ")
        
        for newid2 in newid {
            val  = newid2[0] as! Int64
        }
        print(val);
        
        
        self.changeTitle("Note \(val)", id2: String(onlyid))
        config.set("note_id", value2: String(onlyid))
        return onlyid;
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
        print(returnArr)
        return returnArr
        
    }
    
    func find2 (txt:String) -> Statement {
        
        
        
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
        
        let returnArr = db.prepare("SELECT `note`.`id`, `note`.`title`,`note`.`color`,`note`.`islocked`,`note`.`serverid`,GROUP_CONCAT(`NoteElement`.`contentA`,' '),`note`.`modificationTime` FROM `note` LEFT OUTER JOIN `NoteElement` ON `note`.`id` = `NoteElement`.`noteid` AND `NoteElement`.`contentA` != '' AND `NoteElement`.`type` = 'text'  WHERE \(folderWhere) `note`.`creationTime` != 0 AND  (`note`.`timebomb` = 0 OR  `note`.`timebomb` > \(date2)) AND ( `note`.`title` LIKE '%\(txt)%' OR `NoteElement`.`contentA` LIKE '%\(txt)%' )  GROUP BY `note`.`id` ORDER BY \(sortwithText)")
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
    
    
    func changeNoteFolderOnFolderDelete(folder2:String)  {
        let date = NSDate().timeIntervalSince1970
        let note2 = note.filter(folder == strtoll(folder2,nil,10))
        try! db.run(note2.update(folder <- 0,modificationTime <- Int64(date)))
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
    
    func changeBackground(background2:String,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(background <- background2,modificationTime <- Int64(date)))
    }
    
    func changeTitle(title2:String,id2:String) {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(title <- title2,modificationTime <- Int64(date)))
    }

    func syncSave(title2:String,background2:String,color2:String,folder2:Int64,islocked2:Int64,paper2:String,reminderTime2:Int64,serverid2:String,tags2:String,timebomb2:Int64,creationTime2: String, modificationTime2: String,noteelements2:JSON) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let creationTime3 = dateFormatter.dateFromString(creationTime2)
        let modificationTime3 = dateFormatter.dateFromString(modificationTime2)
        let creationTime4 = Int64((creationTime3?.timeIntervalSince1970)! )
        let modificationTime4 = Int64((modificationTime3?.timeIntervalSince1970)!)
        let count = try db.scalar(note.filter(serverid == serverid2).count)
        
        
        var noteLocalId:Int64!
        
        
        
        if(count > 0)
        {
            
        
            let fol2 = note.filter(serverid == serverid2 && modificationTime < modificationTime4  )
            let id2 = db.pluck(fol2)
            if((id2) != nil)
            {
                noteLocalId = id2![id]
                noteElement.deleteAllNoteElement(noteLocalId)
            }
            
            
            
            try! db.run(fol2.update(title <- title2, background <- background2, color <- color2, folder <- folder2 , islocked <- islocked2, paper <- paper2,reminderTime <- reminderTime2, tags <- tags2, timebomb <- timebomb2, modificationTime <- modificationTime4 ) )
        }
        else
        {
            let insert = note.insert( title <- title2, background <- background2, color <- color2, folder <- folder2 , islocked <- islocked2, paper <- paper2,reminderTime <- reminderTime2, tags <- tags2, timebomb <- timebomb2, modificationTime <- modificationTime4 , creationTime <-  creationTime4,serverid <- serverid2 )
            
            noteLocalId = try! db.run(insert)
        }
        
        if(noteLocalId != nil)
        {
            print(noteelements2);
            for noteElement2 in noteelements2.array! {
                let filename = noteElement2["content"].string!
                let getFilePath = path + "/" + filename
                
                let checkValidation = NSFileManager.defaultManager()
                let fileType = noteElement2["type"].string!
                if (checkValidation.fileExistsAtPath(getFilePath) && (fileType == "image" || fileType == "scribble" || fileType == "audio" ))
                {
                    print("FILE AVAILABLE");
                }
                else if(fileType == "image" || fileType == "scribble" || fileType == "audio" )
                {
                    print("FILE NOT AVAILABLE");
                    
                    
                    request.download(ServerURL + "user/getmedia?file=" + filename, parameters: nil, progress: {(complete: Double) in
                        print("percent complete: \(complete)")
                        }, completionHandler: {(response: HTTPResponse) in
                            print("download finished!")
                            if let err = response.error {
                                print("error: \(err.localizedDescription)")
                                return //also notify app of failure as needed
                            }
                            if let url = response.responseObject as? NSURL {
                                //we MUST copy the file from its temp location to a permanent location.
                                if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String! {
                                    if let fileName = response.suggestedFilename {
                                        print(path + "/" + filename);
                                        let newPath = NSURL(fileURLWithPath: path + "/" + filename )
                                        let fileManager = NSFileManager.defaultManager()
                                        
                                        do {
                                        try fileManager.moveItemAtURL(url, toURL: newPath)
                                        }
                                        catch {
                                            print("File Exists");
                                        }
                                    }
                                }
                            }
                            
                    })
                    
                }
                
                noteElement.create(
                    noteElement2["content"].string! ,
                    contentA2: noteElement2["contentA"].string!,
                    contentB2: noteElement2["contentB"].string!,
                    type2: noteElement2["type"].string!,
                    order2: strtoll( noteElement2["order"].string!,nil,10 ),
                    noteid2: noteLocalId
                )
            }
        }
        
    }
    
    func setServerId(serverid2:String,id2:String) {
        print(id2);
        print(serverid2);
        let id3 = strtoll(id2,nil,10)
        let fol = note.filter(id == id3)
        do {
            
        try! db.run(fol.update(serverid <- serverid2))
    
        }
        catch {
            print("Value issue");
        }
    }
    
    func deleteServer(serverID2: String) {
        let fol = note.filter(serverid == serverID2)
        let noteid1 =  db.pluck(fol)
        try! db.run(fol.delete())
//        noteElement.deleteAllNoteElement(noteid1![id])
        
    }
    
    func servertolocal(completion : ((JSON)->Void)) {
        
        let ServerDateFormatter = NSDateFormatter()
        ServerDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var ServerToLocal = ServerDateFormatter.stringFromDate(NSDate( timeIntervalSince1970: NSTimeInterval( strtoll(config.get("note_server_to_local"),nil,10) ) ))
        
        
        if(ServerToLocal == "")
        {
            ServerToLocal = "1970-01-01 00:00:00";
        }
        
        let params:Dictionary<String,AnyObject> = ["modifytime": ServerToLocal,
            "user":config.get("user_id")]
        
        do {
        request.POST(ServerURL+"note/servertolocal", parameters: params, completionHandler: {(response: HTTPResponse) in
           print(response.responseObject)
            if(response.responseObject != nil){
            
            let json = JSON(data: response.responseObject as! NSData)
            
            

            for (key,subJson):(String, JSON) in json {
                //Do something you want
                
                if(subJson["_id"] != nil)
                {
                    if(subJson["creationtime"].string == "") {
                        print(subJson["_id"])
                        self.deleteServer(subJson["_id"].string!)
                    }
                    else {
                        var folder3:Int64 = 0;
                        if(subJson["folder"].string == "")
                        {
                            folder3 = Folder().getIdFromServerID(subJson["folder"].string!);
                        }
                        print(subJson)
                        var parernote = ""
                        
                        if(subJson["paper"].stringValue == ""){
                            parernote = "";
                        }else{
                            parernote = subJson["paper"].string!
                        }
                        
                        
                        self.syncSave(
                            subJson["title"].string!,
                            background2:subJson["background"].string!,
                            color2:subJson["color"].string! ,
                            folder2:folder3,
                            islocked2:strtoll(subJson["islocked"].string!,nil,10) ,
                            paper2: subJson["paper"].stringValue == "" ? "" : subJson["paper"].stringValue,
                            reminderTime2:strtoll(subJson["remindertime"].string!,nil,10),
                            serverid2:subJson["_id"].string!,
                            tags2:subJson["tags"].string!,
                            timebomb2:strtoll(subJson["timebomb"].string!,nil,10),
                            creationTime2: subJson["creationtime"].string!,
                            modificationTime2: subJson["modifytime"].string!,
                            noteelements2: subJson["noteelements"]
                        )
                    }
                    
                    // change modify time to server
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let modval = dateFormatter.dateFromString(subJson["modifytime"].string!)! as NSDate
                    config.set("note_server_to_local", value2: String(Int64(modval.timeIntervalSince1970)))
                }
                
                
            }
            }
            self.localtoserver{(json:JSON) -> () in }
        })
            completion(1)
        }
        catch {
            print("ERROR")
            completion(0)
        }
    }
    
    
    
    func getNoteStatementToSync() -> Statement {
        let lastLocaltoServer = strtoll(config.get("note_local_to_server"),nil,10)
        let query = db.prepare("SELECT * FROM (SELECT `note`.`id`,`note`.`title`,`note`.`creationTime`,`note`.`modificationTime`,`note`.`background`,`color`, `folder`.`id` as `folder` ,`note`.`islocked`,`note`.`paper`,`note`.`reminderTime`,`note`.`serverid`,`note`.`tags`,`note`.`timebomb` FROM `note` LEFT OUTER JOIN `folder` ON `folder`.`id` =  `note`.`folder` ORDER BY `note`.`modificationTime` ASC) WHERE `modificationTime` > \(lastLocaltoServer) ")
        return query
    }
    
    func localtoserver(completion : ((JSON)->Void)) {
        print("LOCAL IS HERE");
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
               
                if(row[noteElement.type] == "image" || row[noteElement.type] == "scribble" || row[noteElement.type] == "audio"  )
                {
                     request.GET(ServerURL+"user/searchmedia?file="+row[noteElement.content]!, parameters: nil, completionHandler: {(response: HTTPResponse) in
                        let json = JSON(data: response.responseObject as! NSData)
                        if(json["value"].string == "false")
                        {
                            print("Upload file" + row[self.noteElement.content]!)
                            print(path);
                            let fileUrl = NSURL(fileURLWithPath: path+"/"+row[self.noteElement.content]!)
                            request.upload(ServerURL + "user/mediaupload", method: .POST, parameters: ["file": HTTPUpload(fileUrl: fileUrl)], progress: { (value: Double) in
                                print("progress: \(value)")
                                }, completionHandler: { (response: HTTPResponse) in
                            })
                            
                            
                        }
                     })
                }
                
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
            
            
            
            var folder2 = row[6] as! Int64!
            if(folder2 == nil)
            {
                folder2 = 0
            }
            
            
            
            let params : Dictionary<String,AnyObject>  = ["title":row[1] as! String!,
                "creationtime":  creationDateStr ,
                "modifytime": ServerDateFormatter.stringFromDate(mofificationDate2) ,
                "user":config.get("user_id"),
                "_id":row[10] as! String!,
                "background": row[4] as! String!,
                "color": row[5] as! String!,
                "folder": String(folder2),
                "islocked": String(row[7] as! Int64!),
                "paper": row[8] as! String!,
                "remindertime": String(row[9] as! Int64!),
                "tags": row[11] as! String!,
                "timebomb": String(row[12] as! Int64!),
                "noteelements" : jsonNoteElement,
            ]
            print(params);
            print("GOINT INSIDE");
            
            print("CHECKING THE NOTE ELEMENT");
            print(params);
            
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
        completion(1)
    }
}