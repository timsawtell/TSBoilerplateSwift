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

var dDeviceOrientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
var isPortrait = dDeviceOrientation == UIInterfaceOrientation.Portrait || dDeviceOrientation == UIInterfaceOrientation.PortraitUpsideDown
var isLandscape = dDeviceOrientation == UIInterfaceOrientation.LandscapeLeft || dDeviceOrientation == UIInterfaceOrientation.LandscapeRight
