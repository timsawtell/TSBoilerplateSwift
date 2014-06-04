//
//  CommandRunner.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class CommandRunner {
    
    let sharedOperationQueue: NSOperationQueue = NSOperationQueue()
    
    func executeCommand(command :Command) {
        if command.isKindOfClass(AsynchronousCommand) {
            self.sharedOperationQueue.addOperation(command)
            returng
        }
        command.execute()
    }
    
}
