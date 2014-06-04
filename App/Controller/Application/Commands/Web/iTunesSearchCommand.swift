//
//  iTunesSearchCommand.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class iTunesSearchCommand: AsynchronousCommand {
    override func execute()  {
        NSLog("in iTunesSearchCommand, executing")
        self.finish()
    }
}