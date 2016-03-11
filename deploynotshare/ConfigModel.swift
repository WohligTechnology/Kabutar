//
//  FoderModel.swift
//  deploynotshare
//
//  Created by Chintan Shah on 31/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import Foundation
import SQLiteCipher

public class Config {
    
    
    
    public let db = AppDelegate.getDatabase()
    public let config = Table("config")
    public let id = Expression<Int64>("id")
    public let name = Expression<String?>("name")
    public let value = Expression<String?>("value")
    
    init() {
        
        try! db.run(config.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(name)
            t.column(value)
        })
        
    }
    
    func get(name2:String) -> String  {
        
        var returnStr = "";
        let count =  db.scalar(config.filter(name == name2).count )
        if(count == 0)
        {
            
        }
        else
        {
            let newval =  db.pluck(config.filter(name == name2) )
            returnStr = newval![value]!
        }
       
        return returnStr;
        
    }
    
    func set(name2:String, value2: String) {
        
        let count =  db.scalar(config.filter(name == name2).count )
        if(count == 0)
        {
            try! db.run(config.insert(name <- name2, value <- value2))
        }
        else
        {
            let updaterow = config.filter(name == name2)
            try! db.run(updaterow.update(value <- value2))
        }
        
    }
    
    
    
    func flush() {
        try! db.run(config.delete())
    }
    
    func logoutFlush() {
        self.flush()
        try! db.execute("DROP TABLE note")
        try! db.execute("DROP TABLE NoteElement")
        try! db.execute("DROP TABLE folder")
    }
    
   

    
}