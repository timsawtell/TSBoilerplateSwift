//
//  NSError.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 27/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

extension NSError {
    class func errorWithCode(code: Int, text: String) -> NSError {
        return NSError(domain: kReverseDomainName, code: code, userInfo: [NSLocalizedDescriptionKey:text])
    }
}