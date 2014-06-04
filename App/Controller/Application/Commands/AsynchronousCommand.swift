//
//  AsynchronousCommand.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

//not sure if this is ever needed typealias commandCompletionBlock = ((error: NSError?) -> Void)!

class AsynchronousCommand : Command {
    
    var commandCompletionBlock: (error: NSError?) -> Void = { (error: NSError?) -> Void in
        //a completion block with nothing by default
    }
    var error: NSError? = nil
    var _isExecuting: Bool = false
    var _isFinished: Bool = false
    weak var parentCommand: AsynchronousCommand? = nil
    var subCommands: AsynchronousCommand[]
    
    init() {
        subCommands = AsynchronousCommand[]()
    }
    
    override var executing: Bool {
        get {
            return self._isExecuting
        }
    }
    override var finished: Bool {
        get {
            return self._isFinished
        }
    }
    
    override func main() {
        weak var weakSelf: AsynchronousCommand? = self
        self.completionBlock = {
            var block: dispatch_block_t
            if let strongSelf = weakSelf {
                dispatch_async(dispatch_get_main_queue()) {
                    strongSelf.commandCompletionBlock(error: strongSelf.error)
                }
            }
        }
        self.execute()
    }
    
    override func start() {
        self.setExecuting(true)
        self.main()
    }
    
    override func cancel() {
        self.stopAllSubCommandsAndDependants()
        self.willChangeValueForKey("isCancelled")
        super.cancel()
        self.didChangeValueForKey("isCancelled")
        if self.executing {
            self.finish()
        }
    }
    
    func setExecuting(executing: Bool) {
        self.willChangeValueForKey("isExecuting")
        self._isExecuting = executing
        self.didChangeValueForKey("isExecuting")
    }
    
    func setFinished(finished: Bool) {
        self.willChangeValueForKey("isFinished")
        self._isFinished = finished
        self.didChangeValueForKey("isFinished")
    }
    
    func finish() {
        
        if nil != self.error {
            self.stopAllSubCommandsAndDependants()
        }
        
        // if I am a subcommand (I am if I have a parentCommand) then check if my parent has no other sub commands running. If so, then finish the parent as well
        if let parent = self.parentCommand {
            var runningSubCommands: Bool = false
            for cmd: AsynchronousCommand in parent.subCommands {
                //if equal { continue } // don't look at self in this loop
                if cmd.isEqual(self) { continue }
                if !cmd.finished {
                    runningSubCommands = true
                    break
                }
            }
            
            if !runningSubCommands {
                self.setExecuting(false)
                self.setFinished(true)
                self.parentCommand?.finish()
                self.parentCommand?.clearSubCommands() // clear the reference to sub commands, allows dealloc
                return
            }
        }
        self.setFinished(true)
        self.setExecuting(false)
    }
    
    func stopAllSubCommandsAndDependants() {
        for cmd in self.subCommands {
            cmd.cancel()
        }
        
        self.clearSubCommands()
        //todo:
        /*
        for (NSOperation *op in [TSCommandRunner sharedOperationQueue].operations) {
            if ([op.dependencies containsObject:self]) {
                [op cancel];
            }
        }
        */
    }
    
    func addSubCommand(command: AsynchronousCommand) {
        command.parentCommand = self;
        self.subCommands.append(command)
    }
    
    func clearSubCommands() {
        self.subCommands = AsynchronousCommand[]()
    }
    
}