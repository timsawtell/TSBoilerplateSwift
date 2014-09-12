//
//  TSPullToRefreshView.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 24/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation
import QuartzCore

enum TSPullState: Int {
    case Pulling = 0, Normal, Loading
}

@objc protocol TSPullViewDelegate {
    func TSPullDidTriggerRefresh(view: TSPullView)
    func TSPullDidTriggerLoadMore(view: TSPullView)
    func TSPullDelegateIsLoadingData() -> Bool
    optional func TSPullViewLastUpdated(pullView: TSPullView) -> NSDate
}

class TSPullView: UIView {
    var state: TSPullState = .Normal
    var lastUpdatedLabel: UILabel
    var statusLabel: UILabel
    var layerToRotate: CALayer
    var isForBottomOfScrollView = false
    var delegate: TSPullViewDelegate?
    let flipDuration = 0.18
    let dragHeightThreshold: CGFloat = 80.0 // 80 points past top will trigger a state change
    var highlighterView: HighlighterView // the slidy uppy whitey boxy thing
    
    init(frame: CGRect, isForBottomOfView: Bool) {
        isForBottomOfScrollView = isForBottomOfView
        layerToRotate = CALayer()
        if !isForBottomOfScrollView {
            lastUpdatedLabel = UILabel(frame: CGRectMake(0, frame.size.height - 30, frame.size.width, 20))
            statusLabel = UILabel(frame: CGRectMake(0, frame.size.height - 48, frame.size.width, 20))
            layerToRotate.frame = CGRectMake(25, frame.size.height - 65, 30, 55)
        } else {
            lastUpdatedLabel = UILabel(frame: CGRectMake(0, 20, frame.size.width, 20))
            statusLabel = UILabel(frame: CGRectMake(0, 2, frame.size.width, 20))
            layerToRotate.frame = CGRectMake(25, 7, 30, 55)
        }
        
        lastUpdatedLabel.autoresizingMask = .FlexibleWidth
        lastUpdatedLabel.font = UIFont.systemFontOfSize(12)
        lastUpdatedLabel.textColor = UIColor.darkGrayColor()
        lastUpdatedLabel.shadowOffset = CGSizeMake(0, 1)
        lastUpdatedLabel.textAlignment = .Center
        
        statusLabel.autoresizingMask = .FlexibleWidth
        statusLabel.font = UIFont.systemFontOfSize(13)
        statusLabel.textColor = UIColor.blackColor()
        statusLabel.shadowOffset = CGSizeMake(0, 1)
        statusLabel.textAlignment = .Center
        
        layerToRotate.contentsGravity = kCAGravityResizeAspect
        layerToRotate.contents = UIImage(named:"blackArrow").CGImage
        layerToRotate.contentsScale = UIScreen.mainScreen().scale
        
        highlighterView = HighlighterView(frame: CGRectMake(0, -7, layerToRotate.frame.size.width, 7))
        weak var weakHLV = highlighterView
        var height = layerToRotate.frame.size.height
        UIView.animateWithDuration(1.2, delay: 0.2, options: .Repeat,
            animations: {
                if let strongHLV = weakHLV {
                    strongHLV.frame = CGRectSetY(strongHLV.frame, strongHLV.frame.origin.y + height + strongHLV.frame.size.height  ) // scroll up the rotate image
                }
            }, completion: nil)
        layerToRotate.addSublayer(highlighterView.layer)
        
        super.init(frame: frame)
        autoresizingMask = .FlexibleWidth
        backgroundColor = UIColor.whiteColor()
        addSubview(lastUpdatedLabel)
        addSubview(statusLabel)
        layer.addSublayer(layerToRotate)
        setState(.Normal)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setState(newState: TSPullState) {
        switch newState {
            case .Pulling:
                layerToRotate.hidden = false
                if !isForBottomOfScrollView {
                    statusLabel.text = "Release to refresh"
                } else {
                    statusLabel.text = "Release to load more"
                }
                highlighterView.hidden = true
                
                weak var weakSelf = self
                var flash = CABasicAnimation(keyPath: "opacity")
                flash.fromValue = 1
                flash.toValue = 0.4
                flash.duration = 0.7
                flash.autoreverses = true
                flash.repeatCount = MAXFLOAT
                layerToRotate.addAnimation(flash, forKey: "flash")
            
            case .Normal:
                layerToRotate.hidden = false
                if !isForBottomOfScrollView {
                    statusLabel.text = "Pull down to refresh"
                } else {
                    statusLabel.text = "Pull up to load more"
                    layerToRotate.transform = CATransform3DMakeRotation(DegreesToRadians(180), 0, 0, 1)
                }
                
                if !isForBottomOfScrollView {
                    statusLabel.text = "Pull down to refresh"
                } else {
                    statusLabel.text = "Pull up to load more"
                }
                
                highlighterView.hidden = false
                layerToRotate.removeAnimationForKey("flash")
            
            case .Loading:
                highlighterView.hidden = false
                layerToRotate.removeAnimationForKey("flash")
                statusLabel.text = "Loading..."
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                layerToRotate.hidden = true
                CATransaction.commit()
            
        }
        state = newState
    }
    
    func refreshLastUpdatedDate() {
        if let myDelegate = delegate {
            if let date = myDelegate.TSPullViewLastUpdated?(self) {
                var df = NSDateFormatter()
                df.dateStyle = .ShortStyle
                df.timeStyle = .ShortStyle
                lastUpdatedLabel.text = "Last updated: \(df.stringFromDate(date))"
                return
            }
        }
        lastUpdatedLabel.text = ""
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = max(scrollView.contentSize.height - scrollView.frame.size.height, 0)
        
        if scrollView.dragging {
            var isLoading = false
            if let myDelegate = delegate {
                isLoading = myDelegate.TSPullDelegateIsLoadingData()
            }
            
            if isLoading { return }
            if !isForBottomOfScrollView {
                if state == .Pulling && scrollView.contentOffset.y > -85 && scrollView.contentOffset.y < 0 && !isLoading {
                    setState(.Normal)
                } else if state == .Normal && scrollView.contentOffset.y < -85 && !isLoading {
                    setState(.Pulling)
                }
            } else if currentOffset > maximumOffset {
                if state == .Pulling && abs(maximumOffset - currentOffset) < 85 && !isLoading {
                    setState(.Normal)
                } else if state == .Normal && abs(maximumOffset - currentOffset) > 85 && !isLoading {
                    setState(.Pulling)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView) {
        var isLoading = false
        if let myDelegate = delegate {
            isLoading = myDelegate.TSPullDelegateIsLoadingData()
        }
        if isLoading { return }
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = max(scrollView.contentSize.height - scrollView.frame.size.height, 0)
        
        if currentOffset <= -dragHeightThreshold && !isLoading {
            if let myDelegate = delegate {
                myDelegate.TSPullDidTriggerRefresh(self)
            }
            setState(.Loading)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.7)
            scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
            UIView.commitAnimations()
        } else if (maximumOffset - currentOffset < -65) {
            if let myDelegate = delegate {
                myDelegate.TSPullDidTriggerLoadMore(self)
            }
            setState(.Loading)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.7)
            if maximumOffset < currentOffset {
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
            }
            UIView.commitAnimations()
        }
    }
    
    func scrollViewDataSourceDidFinishLoading(scrollView: UIScrollView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        UIView.commitAnimations()
        refreshLastUpdatedDate()
        setState(.Normal)
    }
}

class HighlighterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}