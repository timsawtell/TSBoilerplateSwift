//
//  Model.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class Model :NSObject, NSSecureCoding {
    
    var strings: String[] = [];
    
    init() {
        
    }
    
    func save() {
        let data = CommandCenter.securelyArchiveRootObject(self, key: kModelArchiveKey)
        if !data?.writeToFile(CommandCenter.pathForModel(), atomically: true) {
            NSLog("counl't write model to disk")
        }
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    //NSSecureCoding
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(strings as NSArray, forKey: "strings")
    }
    
    init(coder aDecoder: NSCoder!) {
        strings = aDecoder.decodeObjectOfClass(NSArray.self, forKey: "strings") as String[]
    }
}