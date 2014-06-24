//
//  CGRectHelper.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 24/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

func DegreesToRadians(degrees: Float) -> Float {
    return degrees * Float(M_PI) / 180
}

func RadiansToDegrees(radians: Float) -> Float {
    return radians * 180 / Float(M_PI)
}

func CGRectSetX(rect: CGRect, x: Float) -> CGRect {
    var r = rect
    r.origin.x = x
    return r
}

func CGRectSetY(rect: CGRect, y: CGFloat) -> CGRect {
    var r = rect
    r.origin.y = y
    return r
}

func CGRectSetSize(rect: CGRect, size: CGSize) -> CGRect {
    var r = rect
    r.size = size
    return r
}

func CGRectSetWidth(rect: CGRect, width: CGFloat) -> CGRect {
    var r = rect
    r.size.width = width
    return r
}

func CGRectSetHeight(rect: CGRect, height: CGFloat) -> CGRect {
    var r = rect
    r.size.height = height
    return r
}

func CGRectCenteredInnerRect(centerPoint: CGPoint, size: CGSize) -> CGRect {
    var r = CGRect()
    r.origin = CGPointMake(centerPoint.x - (size.width / 2), centerPoint.y - (size.height / 2))
    r.size = size
    return r
}

func CGRectCenter(rect: CGRect) -> CGPoint {
    return CGPointMake(rect.origin.x + (rect.size.width / 2), rect.origin.y + (rect.size.height / 2))
}

func CGRectCenteredInsideRect(outerRect: CGRect, innerRect: CGRect) -> CGRect {
    return CGRectCenteredInnerRect(CGRectCenter(outerRect), innerRect.size)
}

