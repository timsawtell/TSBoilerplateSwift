//
//  AsynchronousCommand.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

typealias commandCompletionBlock = ((error: NSError) -> Void)!

class AsynchronousCommand : Command {
    
    var finalCompletionBlock: commandCompletionBlock?
    var error: NSError? = nil
    var _isExecuting: Bool = false
    var _isFinished: Bool = false
    
    override var asynchronous: Bool { get {
        return true
    }}
    override var concurrent: Bool { get {
        return true
    }}
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
                    if strongSelf.error? {
                        strongSelf.finalCompletionBlock!(error: strongSelf.error!)
                    }
                }
            }
        }
        
        self.finish()
    }
    
    override func start() {
        self.main()
    }
    
    func finish() {
        
        self.willChangeValueForKey("isFinished")
        self._isFinished = true
        self.didChangeValueForKey("isFinished")
        
        self.willChangeValueForKey("isExecuting")
        self._isExecuting = false
        self.didChangeValueForKey("isExecuting")
    }
}