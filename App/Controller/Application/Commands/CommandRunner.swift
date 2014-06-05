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
            if asyncCommand.finished || asyncCommand.cancelled { return }
            sharedOperationQueue.addOperation(asyncCommand)
            return
        }
        command.execute()
    }
    
}
