//
//  DemoViewController.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation
import UIKit

class DemoViewController : TSViewController {
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        NSLog("before it is \(model.strings.count)")
        model.strings.append("\(NSDate.date)")
        model.save()
        NSLog("after it is \(model.strings.count)")
        
        
        var asyncCommand = iTunesSearchCommand()
        asyncCommand.commandCompletionBlock = {error in
            NSLog("command finished")
        }
        commandRunner.executeCommand(asyncCommand)
    }
}