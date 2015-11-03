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
    public let Note = Table("note")
    public let id = Expression<Int64>("id")
    public let title = Expression<String?>("title")
    public let creationTime = Expression<Int64>("creationTime")
    public let modificationTime = Expression<Int64>("modificationTime")
    
    public let background = Expression<String?>("background")
    public let color = Expression<String?>("color")
    public let folder = Expression<Int64>("folder")
    public let islocked = Expression<Int64>("islocked")
    public let paper = Expression<String?>("paper")
    public let remindertime = Expression<Int64>("remindertime")
    public let serverid = Expression<String?>("serverid")
    public let tags = Expression<String?>("tags")
    public let timebomb = Expression<String?>("timebomb")
    
    init() {
        
        try! db.run(Note.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(title)
            t.column(creationTime)
            t.column(modificationTime)
            t.column(background)
            t.column(color)
            t.column(folder)
            t.column(islocked)
            t.column(paper)
            t.column(remindertime)
            t.column(serverid)
            t.column(tags)
            t.column(timebomb)
            })
        
    }
    
    func create(name2:String) -> AnySequence<Row>  {
        let insert = folder.insert( name <- name2, creationTime <- 12345, modificationTime <- 12345, order <- 1, serverID <- "123")
        try! db.run(insert)
        return try! db.prepare(folder)
    }
    
    func find() -> AnySequence<Row>  {
        return try! db.prepare(folder)
    }
    
    func edit(name2:String,id2:String) -> AnySequence<Row>  {
        let id3 = strtoll(id2,nil,10)
        let fol = folder.filter(id == id3)
        try! db.run(fol.update(name <- name2))
        return try! db.prepare(folder)
    }
    
    func delete(id2:String) -> AnySequence<Row>  {
        let id3 = strtoll(id2,nil,10)
        let fol = folder.filter(id == id3)
        try! db.run(fol.delete())
        return try! db.prepare(folder)
    }
    
    
}