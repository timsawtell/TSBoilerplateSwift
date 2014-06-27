//
//  Singletons.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

let GlobalCommandRunner = CommandRunner()
let GlobalModel = Model.sharedModel()!

let GlobalManager = setupGlobalManager()
let GlobalSession = setupGlobalSession()
