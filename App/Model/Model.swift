//
//  Model.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class Model :NSObject, NSSecureCoding {
    
    var strings = [NSString]()
    var books = [Book]()
    weak var currentBook: Book?

    override init() {
        
    }
    
    func save() {
        let data = CommandCenter.securelyArchiveRootObject(self, key: kModelArchiveKey)
        if !(data?.writeToFile(kPathForModelFile, atomically: true) != nil) {
            NSLog("couldn't write model to disk")
        }
    }
   
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    // NSSecureCoding
    // There is a bug with NSSecureCoding for collection types (i.e. arrays). I have filed a Radar bug report and when apple fix their sh!t I'll update this.
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(strings, forKey: "strings")
        aCoder.encodeObject(books, forKey: "books")
    }
    
    required init(coder aDecoder: NSCoder) {
        strings = aDecoder.decodeObjectOfClass(NSArray.self, forKey: "strings") as! [String]
        books   = aDecoder.decodeObjectOfClass(NSArray.self, forKey: "books") as! [Book]
    }
}