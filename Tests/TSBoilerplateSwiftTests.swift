//
//  TSBoilerplateSwiftTests.swift
//  TSBoilerplateSwiftTests
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import XCTest

class TSBoilerplateSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    * As an asynchronous command I should be able to add sub commands.
    * when I add subcommands they should have me as their parent command
    * when I cancel a parent command, the subcommands should also be cancelled
    */
    func testSubCommands() {
        var a: AsynchronousCommand = AsynchronousCommand()
        var b: AsynchronousCommand = AsynchronousCommand()
        var c: AsynchronousCommand = AsynchronousCommand()
        
        c.commandCompletionBlock = { (error: NSError?) -> Void in
            b.cancel()
        }
        c.addSubCommand(b)
        b.addSubCommand(a)
        
        XCTAssertEqual(1, c.subCommands.count, "c didn't have a subcommand")
        XCTAssertEqual(1, b.subCommands.count, "b didn't have a subcommand")
        XCTAssertEqual(b.parentCommand!, c, "the parentCommand for b should be c");
        XCTAssertEqual(a.parentCommand!, b, "the parentCommand for a should be b");
        
        commandRunner.executeCommand(c)
        
        var commandFinished = expectationWithDescription("command finished")
        c.finish()
        
        dispatch_after(2, dispatch_get_current_queue(), { dispatch_block_t in
            XCTAssertTrue(b.cancelled, "b wasn't cancelled")
            XCTAssertTrue(a.cancelled, "a wasn't cancelled")
            commandFinished.fulfill()
        })
        
        waitForExpectationsWithTimeout(4, handler: nil)
    }
    
}
