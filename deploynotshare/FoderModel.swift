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
    
    
    let db = AppDelegate.getDatabase()
    let folder = Table("folder")
    let id = Expression<Int64>("id")
    let name = Expression<String?>("name")
    let creationTime = Expression<Int64>("creationTime")
    let modificationTime = Expression<Int64>("modificationTime")
    let order = Expression<Int64>("order")
    let serverID = Expression<String>("serverid")
    
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
    
    func create() {
        let insert = folder.insert(name <- "alice@mac.com", creationTime <- 12345, modificationTime <- 12345, order <- 1, serverID <- "123")
        try! db.run(insert)
    }
    
    func find() -> AnySequence<Row>  {
        return try! db.prepare(folder)
    }
        
    
}