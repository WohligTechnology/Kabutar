//
//  FoderModel.swift
//  deploynotshare
//
//  Created by Chintan Shah on 31/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import Foundation
import SQLiteCipher

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
    
    func create(name2:String) {
        let insert = folder.insert( name <- name2, creationTime <- 12345, modificationTime <- 12345, order <- 1, serverID <- "123")
        try! db.run(insert)
    }
    
    func find() -> AnySequence<Row>  {
        return try! db.prepare(folder)
    }
    
    func edit(name:String,id:String) -> AnySequence<Row>  {
        let id2 = strtoll(id,nil,10)
        return try! db.prepare(folder)
    }

    func delete(name:String,id:String) -> AnySequence<Row>  {
        
        return try! db.prepare(folder)
    }
        
    
}