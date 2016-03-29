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
    
    // validation functions
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        var result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
    func isValidPhone(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        var phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        var result =  phoneTest.evaluateWithObject(value)
        
        return result
        
    }
//    func isBlank(value: String) -> Bool {
//        let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        return trimmed.isEmpty
//    }
}

extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersInString: "+0123456789").invertedSet
        var filtered:NSString!
        let inputString:NSArray = self.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        return  self == filtered
        
    }
}


