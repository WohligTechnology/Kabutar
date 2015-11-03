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