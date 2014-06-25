//
//  UIColor.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 24/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

func ColorWithHexString(hexString: String) -> UIColor {
    var cString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    if cString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 6 {
        return UIColor.blackColor()
    }
    if cString.hasPrefix("0X") {
        cString = cString.substringFromIndex(2)
    }
    if cString.hasPrefix("#") {
        cString = cString.substringFromIndex(1)
    }
    if cString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 6 {
        return UIColor.blackColor()
    }
    
    var rString = cString.substringToIndex(2)
    var gString = cString.substringFromIndex(2).substringToIndex(2)
    var bString = cString.substringFromIndex(4).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner.scannerWithString(rString).scanHexInt(&r)
    NSScanner.scannerWithString(gString).scanHexInt(&g)
    NSScanner.scannerWithString(bString).scanHexInt(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}