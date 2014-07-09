//
//  AsynchronousCommand.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

typealias commandCompletionBlock = ((error: NSError?) -> Void)!

class AsynchronousCommand : Command {
    
    var commandCompletionBlock: (error: NSError?) -> Void = { error in
        //a completion block with nothing by default
    }
    var error: NSError? = nil
    var _isExecuting: Bool = false
    var _isFinished: Bool = false
    weak var parentCommand: AsynchronousCommand? = nil
    var subCommands: [AsynchronousCommand]
    
    init() {
        subCommands = [AsynchronousCommand]()
    }
    
    override var executing: Bool {
        get {
            return _isExecuting
        }
    }
    override var finished: Bool {
        get {
            return _isFinished
        }
    }
    
    override func main() {
        weak var weakSelf: AsynchronousCommand? = self
        self.completionBlock = {
            if let strongSelf = weakSelf {
                dispatch_async(dispatch_get_main_queue()) {
                    strongSelf.commandCompletionBlock(error: strongSelf.error)
                }
            }
        }
        execute()
    }
    
    override func start() {
        setExecuting(true)
        main()
    }
    
    // we have to cater for some pretty shitty old KVO patterns. Here, take up more lines of code why dont you.
    
    override func cancel() {
        stopAllSubCommandsAndDependants()
        willChangeValueForKey("isCancelled")
        super.cancel()
        didChangeValueForKey("isCancelled")
        if executing {
            finish()
        }
    }
    
    func setExecuting(setExecuting: Bool) {
        if executing == setExecuting {return}
        willChangeValueForKey("isExecuting")
        _isExecuting = setExecuting
        didChangeValueForKey("isExecuting")
    }
    
    func setFinished(setFinished: Bool) {
        if finished == setFinished {return}
        willChangeValueForKey("isFinished")
        _isFinished = setFinished
        didChangeValueForKey("isFinished")
    }
    
    func finish() {
        
        if nil != error {
            stopAllSubCommandsAndDependants()
        }
        
        if saveModel {
            GlobalModel.save()
        }
        // if I am a subcommand (I am if I have a parentCommand) then check if my parent has no other sub commands running. If so, then finish the parent as well
        if let parent = parentCommand {
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
                setExecuting(false)
                setFinished(true)
                parentCommand?.finish()
                parentCommand?.clearSubCommands() // clear the reference to sub commands, allows dealloc
                return
            }
        }
        setFinished(true)
        setExecuting(false)
    }
    
    func stopAllSubCommandsAndDependants() {
        for cmd in subCommands {
            cmd.cancel()
        }
        
        clearSubCommands()
    }
    
    func addSubCommand(command: AsynchronousCommand) {
        command.parentCommand = self;
        subCommands.append(command)
    }
    
    func clearSubCommands() {
        subCommands = [AsynchronousCommand]()
    }
    
}