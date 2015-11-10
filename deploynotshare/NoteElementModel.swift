//
//  FoderModel.swift
//  deploynotshare
//
//  Created by Chintan Shah on 31/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import Foundation
import SQLiteCipher

public class NoteElement {
    
    
    public let db = AppDelegate.getDatabase()
    public let noteelement = Table("NoteElement")
    public let id = Expression<Int64>("id")
    public let content = Expression<String?>("content")
    public let type = Expression<String?>("type")
    public let order = Expression<String?>("order")
    public let noteid = Expression<Int64?>("noteid")
    
    init() {
        
        try! db.run(noteelement.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(content)
            t.column(type)
            t.column(order)
            t.column(noteid)
        })
        
    }
    
    func get(id2 : Int64) -> Row? {
        let query = noteelement.filter(id == id2)
        return db.pluck( query );
    }
    
    func create(content2 : String ,type2:String, order2: String, noteid2:Int64) -> Int64 {
        let query = noteelement.insert( content <- content2, type <- type2, order <- order2, noteid <- noteid2 )
        let insert = try! db.run(query)
        return insert
    }
    
    func edit(id2:Int64,content2 : String) {
        let toUpdate = noteelement.filter(id == id2)
        try! db.run(toUpdate.update(content <- content2))
    }
    
    func delete(id2:Int64) {
        let todelete = noteelement.filter(id == id2)
        try! db.run(todelete.delete())
    }

    
    func deleteAllNoteElement(noteid2 : Int64) {
        let todelete = noteelement.filter(noteid == noteid2)
        try! db.run(todelete.delete())
    }

    func getAllNoteElement(noteid2 : Int64) -> AnySequence<Row> {
        let query = noteelement.filter(noteid == noteid2)
        return db.prepare( query );
    }
}