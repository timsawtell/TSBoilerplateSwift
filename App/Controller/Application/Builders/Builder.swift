//
//  Builder.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 29/09/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class Builder {
    class func safeAssign(#attemptValue: AnyObject?, defaultValue: AnyObject) ->AnyObject {
        if let realValue: AnyObject = attemptValue {
            return realValue
        }
        return defaultValue
    }
}