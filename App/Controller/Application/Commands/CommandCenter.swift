//
//  CommandCenter.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class CommandCenter {
    
    class func securelyArchiveRootObject(object: NSObject, key: NSString) -> NSData? {
        var data = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data);
        archiver.setRequiresSecureCoding(true)
        archiver.encodeObject(object, forKey: key)
        archiver.finishEncoding()
        return data
    }
    
    class func securelyUnarchiveData(data: NSData, key: NSString) -> AnyObject? {
        var data = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data);
        archiver.setRequiresSecureCoding(true)
        if let returnObject: AnyObject = archiver.decodeObjectForKey(key) {
            return returnObject
        }
        return nil
    }

    class func pathForModel() -> NSString? {
        if let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? String[] {
            if paths.count > 0 {
                var path = paths[0].stringByAppendingPathComponent(kModelFileName)
                return path
            }
        }
        return nil
    }
    
}