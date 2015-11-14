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
    public let contentA = Expression<String?>("contentA")
    public let contentB = Expression<String?>("contentB")
    public let type = Expression<String?>("type")
    public let order = Expression<Int64?>("order")
    public let noteid = Expression<Int64?>("noteid")
    
    
    
    init() {
        try! db.run(noteelement.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(content)
            t.column(contentA)
            t.column(contentB)
            t.column(type)
            t.column(order)
            t.column(noteid)
        })
    }
    
    func get(id2 : Int64) -> Row? {
        let query = noteelement.filter(id == id2)
        return db.pluck( query );
    }
    
    func create(type2:String) -> Int64 {
        let noteid2 = Int64(config.get("note_id"))
        let ordernext = noteelement.filter(noteid == noteid2).order(order.desc)
        var order2:Int64 = 1
        let ordernum = db.pluck( ordernext );
        if(ordernum != nil)
        {
            order2 = ordernum![order]! + 1
        }
        let query = noteelement.insert(type <- type2, order <- order2, noteid <- noteid2 )
        let insert = try! db.run(query)
        return insert
    }
    
    func edit(id2:Int64,content2 : String,contentA2: String, contentB2 : String) {
        let toUpdate = noteelement.filter(id == id2)
        try! db.run(toUpdate.update(content <- content2,contentA <- contentA2,contentB <- contentB2))
        
    }
    
    func delete(id2:Int64) {
        let todelete = noteelement.filter(id == id2)
        try! db.run(todelete.delete())
    }

    
    func deleteAllNoteElement() {
        let noteid2 = Int64(config.get("note_id"))
        let todelete = noteelement.filter(noteid == noteid2)
        try! db.run(todelete.delete())
    }

    func getAllNoteElement() -> AnySequence<Row> {
        let noteid2 = Int64(config.get("note_id"))
        let query = noteelement.filter(noteid == noteid2)
        return db.prepare( query );
    }
}