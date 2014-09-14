//
//  Singletons.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

let GlobalCommandRunner = CommandRunner()               // Global variable. Singleton like usage.
let GlobalModel = CommandCenter.getModelDataFromDisk()  // Global variable. Singleton like usage.