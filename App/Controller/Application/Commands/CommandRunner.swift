//
//  CommandRunner.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class CommandRunner {
    
    let sharedOperationQueue = NSOperationQueue()
    
    func executeCommand(command :Command) {
        if let asyncCommand = command as? AsynchronousCommand {
            sharedOperationQueue.addOperation(command)
            return
        }
        command.execute()
    }
    
}
