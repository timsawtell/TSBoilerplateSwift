//
//  constants.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation
import UIKit

let kModelFileName = "model.dat"
let kModelArchiveKey = "model"

var deviceOrientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
var isPortrait = deviceOrientation == UIInterfaceOrientation.Portrait || deviceOrientation == UIInterfaceOrientation.PortraitUpsideDown
var isLandscape = deviceOrientation == UIInterfaceOrientation.LandscapeLeft || deviceOrientation == UIInterfaceOrientation.LandscapeRight
