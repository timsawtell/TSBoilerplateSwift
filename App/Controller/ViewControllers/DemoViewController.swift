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
        
        NSLog("before it is \(globalModel.strings.count)")
        globalModel.strings.append("\(NSDate.date)")
        globalModel.save()
        NSLog("after it is \(globalModel.strings.count)")
        
        
        var asyncCommand = iTunesSearchCommand()
        asyncCommand.commandCompletionBlock = {error in
            NSLog("command finished")
        }
        globalCommandRunner.executeCommand(asyncCommand)
        
        Model.sharedModel()?.strings.append("e")

    }
}