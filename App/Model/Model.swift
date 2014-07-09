//
//  Model.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

var _modelInstantied = false // just in case a programmer doesnt use the globalModel object from Singleton.swift and instead calls Model.sharedModel()
var _saveFilePath = Model.pathForModel()

class Model :NSObject, NSSecureCoding {
    
    var strings: [String]
    var books: [Book]
    
    init() {
        books = [Book]()
        strings = [String]()
    }
    
    func save() {
        let data = CommandCenter.securelyArchiveRootObject(self, key: kModelArchiveKey)
        if !data?.writeToFile(_saveFilePath, atomically: true) {
            NSLog("couldn't write model to disk")
        }
    }
   
    class func supportsSecureCoding() -> Bool {
        return true
    }

    
    //NSCoding
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(strings, forKey: "strings")
        aCoder.encodeObject(books, forKey: "books")
    }
    
    init(coder aDecoder: NSCoder!) {
        strings = aDecoder.decodeObjectOfClasses(NSSet(objects:[NSArray.self, NSString.self]), forKey: "strings") as [String]
        books   = aDecoder.decodeObjectOfClasses(NSSet(objects:[NSMutableSet.self, Book.self]), forKey: "books") as [Book]
    }
    
    class func sharedModel() -> Model? {
        if _modelInstantied {
            return GlobalModel // return the already instantiated global from Singleton.swift
        }
        var error: NSError?
        let data = NSData.dataWithContentsOfFile(_saveFilePath, options: NSDataReadingOptions.DataReadingMappedIfSafe, error:&error)
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
    
    class func pathForModel() -> NSString? {
        if let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String] {
            if paths.count > 0 {
                var path = paths[0]
                var fm = NSFileManager()
                if !fm.fileExistsAtPath(path) {
                    var error :NSError?
                    fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error)
                }
                path = path.stringByAppendingPathComponent(kModelFileName)
                return path
            }
        }
        return nil
    }
}