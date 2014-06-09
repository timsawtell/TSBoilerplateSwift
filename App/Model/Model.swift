//
//  Model.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

var _modelInstantied = false // just in case a programmer doesnt use the globalModel object from Singleton.swift and instead calls Model.sharedModel()

class Model :NSObject {
    
    var strings: NSMutableArray = []
    var books: NSMutableArray = []
    init() {
        
    }
    
    func save() {
        let data = CommandCenter.archiveRootObject(self, key: kModelArchiveKey)
        if !data?.writeToFile(CommandCenter.pathForModel(), atomically: true) {
            NSLog("counl't write model to disk")
        }
    }
   
    /*
    class func supportsSecureCoding() -> Bool {
        return true
    }
    */
    
    //NSSecureCoding
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(strings, forKey: "strings")
        aCoder.encodeObject(books, forKey: "books")
    }
    
    init(coder aDecoder: NSCoder!) {
        strings = aDecoder.decodeObjectForKey("strings") as NSMutableArray
        books = aDecoder.decodeObjectForKey("books") as NSMutableArray
    }
    
    class func sharedModel() -> Model? {
        if _modelInstantied {
            return globalModel // return the already instantiated global from Singleton.swift
        }
        var path = CommandCenter.pathForModel()
        var error: NSError?
        let data = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error:&error)
        if (nil == data) {
            _modelInstantied = true
            return Model()
        } else {
            if let modelInstance = CommandCenter.unarchiveData(data, ofClass:Model.self, key: kModelArchiveKey) as? Model {
                _modelInstantied = true
                return modelInstance
            }
        }
        return nil
    }
}