//
//  NoteModel.swift
//  deploynotshare
//
//  Created by Chintan Shah on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import Foundation
import SQLiteCipher

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
        let date = NSDate().timeIntervalSince1970
        let date2 = Int64(date)
        var returnArr = db.prepare("SELECT * FROM (SELECT `note`.`id`, `note`.`title`,`note`.`color`,`note`.`islocked`,`NoteElement`.`contentA`,`note`.`modificationTime` FROM `note` LEFT OUTER JOIN `NoteElement` ON `note`.`id` = `NoteElement`.`noteid` AND `NoteElement`.`contentA` != '' AND `NoteElement`.`type` = 'text'  WHERE `note`.`creationTime` != 0 AND  (`note`.`timebomb` = 0 OR  `note`.`timebomb` > \(date)) AND ( `note`.`title` LIKE '%\(txt)%' OR `NoteElement`.`contentA` LIKE '%\(txt)%' ) ORDER BY `NoteElement`.`id` DESC) GROUP BY `id`")
        return returnArr
    }
    
    func edit(title2:String,background2:String,color2:String,folder2:Int64,islocked2:Int64,paper2:String,reminderTime2:Int64,serverid2:String,tags2:String,timebomb2:Int64,id2:String)  {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(title <- title2, creationTime <- Int64(date), modificationTime <- Int64(date), background <- background2, color <- color2, folder <- folder2, islocked <- islocked2,paper <- paper2 , reminderTime <- reminderTime2, serverid <- serverid2, tags <- tags2 , timebomb <- timebomb2))
    }
    
    func delete(id2:String) {
        let date = NSDate().timeIntervalSince1970
        let id3 = strtoll(id2,nil,10)
        let note2 = note.filter(id == id3)
        try! db.run(note2.update(title <- "", creationTime <- 0, modificationTime <- Int64(date), background <- "", color <- "", folder <- 0, islocked <- 0,paper <- "" , reminderTime <- 0, serverid <- "", tags <- "" , timebomb <- 0))
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


    
    
    
}