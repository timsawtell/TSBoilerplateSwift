//
//  CommandRunner.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class CommandRunner: NSObject {
    
    let sharedOperationQueue: NSOperationQueue = NSOperationQueue()
    
    func executeCommand(command :Command) {
        self.sharedOperationQueue.addOperation(command)
    }
    
}

/*
- (void)executeCommand:(Command *)command
{
if ([command isKindOfClass:[AsynchronousCommand class]]) {
AsynchronousCommand *asynchronousCommand = (AsynchronousCommand *)command;
if ([asynchronousCommand isMultiThreaded]) {
if (![[[TSCommandRunner sharedOperationQueue] operations] containsObject:asynchronousCommand]) {
[[TSCommandRunner sharedOperationQueue] addOperation:asynchronousCommand]; // run on any other thread
}
} else {
if (![[[NSOperationQueue mainQueue] operations] containsObject:asynchronousCommand]) {
[[NSOperationQueue mainQueue] addOperation: asynchronousCommand]; // run on thread 0
}
}
} else {
[command execute];
}
}*/