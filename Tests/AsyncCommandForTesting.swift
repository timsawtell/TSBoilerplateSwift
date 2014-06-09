//
//  TestAsyncCommand.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class AsyncCommandForTesting: AsynchronousCommand {
    
    override func execute() {
        // do nothing, just finish
        finish()
    }
}