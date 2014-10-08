//
//  UIColor.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 24/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    convenience init(rgba: String) {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        var moveForward = rgba.hasPrefix("#") ? 1 : 0

        let index = advance(rgba.startIndex, moveForward)
        let hex = rgba.substringFromIndex(index)
        let scanner = NSScanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexLongLong(&hexValue) {
            if hex.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 6 {
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                blue  = CGFloat(hexValue & 0x0000FF) / 255.0
            } else if hex.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 8 {
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            } else {
                print("invalid rgb string, length should be 7 or 9")
            }
        } else {
            println("scan hex error")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}