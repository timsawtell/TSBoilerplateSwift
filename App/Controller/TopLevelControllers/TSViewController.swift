//
//  TSViewController.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation
import UIKit

class TSViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate, TSPullViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var scrollViewToResize: UIScrollView?
    var inputFields = NSMutableArray()
    var activitySuperview = UIView() //for the show message function
    var headerView: TSPullView?
    var footerView: TSPullView?
    var fetchingData = false
    var keyboardShowing = false
    weak var activeControl: UIResponder?
    var hasObservers = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        
        if inputFields.count > 0 {
            var toolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.size.width, 50))
            toolbar.barStyle = UIBarStyle.Default
            toolbar.opaque = false
            toolbar.translucent = true
            
            var nextPrev = UISegmentedControl(items: ["Previous", "Next"])
            nextPrev.momentary = true
            nextPrev.highlighted = true
            nextPrev.addTarget(self, action: "nextPrevChanged:", forControlEvents: UIControlEvents.ValueChanged)
            
            var nextPrevItem = UIBarButtonItem(customView: nextPrev)
            
            toolbar.items = [nextPrevItem,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeKeyboard")];
            toolbar.sizeToFit()
            
            for control : AnyObject in inputFields {
                if control.isKindOfClass(UITextView.self) {
                    let tv = control as! UITextView
                    tv.inputAccessoryView = toolbar
                } else if control.isKindOfClass(UITextField.self) {
                    let tf = control as! UITextField
                    tf.inputAccessoryView = toolbar
                }
            }
        }
        
        if let scrollView = scrollViewToResize {
            scrollView.contentInset = UIEdgeInsetsZero
            scrollView.contentSize = scrollView.frame.size
            
            if wantsPullToRefresh() {
                let headerFrame = CGRectMake(0, -600, scrollView.bounds.size.width, 600)
                headerView = TSPullView(frame: headerFrame, isForBottomOfView: false)
                headerView!.delegate = self
                scrollView.addSubview(headerView!)
            }
            
            if wantsPullToRefreshFooter() {
                let footerFrame = CGRectMake(0, scrollView.bounds.size.height, scrollView.bounds.size.width, 600)
                footerView = TSPullView(frame: footerFrame, isForBottomOfView: true)
                footerView!.delegate = self
                scrollView.addSubview(footerView!)
            }
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
            hasObservers = true
        }
        super.viewDidLoad()
    }
    
    deinit {
        if hasObservers {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if wantsPullToRefreshFooter() {
            setupFooterView()
        }
    }
    
    //MARK:- TSPullView
    func TSPullDidTriggerRefresh(view: TSPullView) {
        fetchData()
        pullDownAction()
    }
    
    func TSPullDidTriggerLoadMore(view: TSPullView) {
        fetchData()
        pullUpAction()
    }
    
    func TSPullDelegateIsLoadingData() -> Bool {
        return fetchingData
    }
    
    func TSPullViewLastUpdated(pullView: TSPullView) -> NSDate {
        return NSDate()
    }
    
    func pullDownAction() {
        showLoadingScreen()
    }
    
    func pullUpAction() {
        showLoadingScreen()
    }
    //END TSPullView
    
    //MARK:- ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y
        var maximumOffset = max(scrollView.contentSize.height - scrollView.frame.size.height, 0)
        if currentOffset < 0 {
            if wantsPullToRefresh() && !keyboardShowing {
                headerView!.scrollViewDidScroll(scrollView)
            }
        } else if currentOffset > maximumOffset {
            if wantsPullToRefreshFooter() && !keyboardShowing {
                footerView!.scrollViewDidScroll(scrollView)
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var currentOffset = scrollView.contentOffset.y
        var maximumOffset = max(scrollView.contentSize.height - scrollView.frame.size.height, 0)
        if currentOffset < 0 {
            if wantsPullToRefresh() && !keyboardShowing {
                headerView!.scrollViewDidEndDragging(scrollView)
            }
        } else if currentOffset > maximumOffset {
            if wantsPullToRefreshFooter() && !keyboardShowing {
                footerView!.scrollViewDidEndDragging(scrollView)
            }
        }
    }

    
    //MARK:- Pull To Refresh and Load data
    func wantsPullToRefresh() -> Bool {
        return false
    }
    
    func wantsPullToRefreshFooter() -> Bool {
        return false
    }
    
    func fetchData() {
        fetchingData = true
    }
    
    func doneLoadingData() {
        fetchingData = false
        if let scrollView = scrollViewToResize {
            headerView?.scrollViewDataSourceDidFinishLoading(scrollView)
            footerView?.scrollViewDataSourceDidFinishLoading(scrollView)
        }
    }
    
    func reloadData() {
        if wantsPullToRefreshFooter() {
            setupFooterView()
        }
        
        if wantsPullToRefresh() || wantsPullToRefreshFooter() {
            weak var weakSelf = self
            waitThenRunOnMain(0.25) {
                if let strongSelf = weakSelf {
                    strongSelf.doneLoadingData()
                }
            }
        }
    }
    
    func setupFooterView() {
        if let scrollView = scrollViewToResize {
            if scrollView.contentSize.height < scrollView.bounds.size.height {
                footerView!.frame = CGRectMake(footerView!.frame.origin.x, scrollView.bounds.size.height, footerView!.frame.size.width, footerView!.frame.size.height)
            } else {
                footerView!.frame = CGRectMake(footerView!.frame.origin.x, scrollView.contentSize.height, footerView!.frame.size.width, footerView!.frame.size.height)
            }
        }
    }
    //END Pull To Refresh and Load data
    
    //MARK:- Keyboard did show and resize scrollview
    func nextPrevChanged(sender: AnyObject) {
        if let segControl: UISegmentedControl = sender as? UISegmentedControl {
            switch segControl.selectedSegmentIndex {
            case 0:
                prevInput()
            case 1:
                nextInput()
            default:
                break
            }
        }
    }
    
    func nextInput() {
        if inputFields.count < 2 { return }
        if let scrollView = scrollViewToResize {
            for var i = 0; i < inputFields.count; i++ {
                if inputFields.objectAtIndex(i) === activeControl {
                    var nextControl: UIControl
                    if (i < inputFields.count - 1) {
                        nextControl = inputFields.objectAtIndex(i+1) as! UIControl
                    } else {
                        nextControl = inputFields.objectAtIndex(0) as! UIControl
                    }
                    
                    UIView.animateWithDuration(0.2, animations:{
                        scrollView.scrollRectToVisible(nextControl.frame, animated: true)
                        }, completion: ({ finished in
                            nextControl.becomeFirstResponder()
                        }))
                    
                    break
                }
            }
        }
    }
    
    func prevInput() {
        if inputFields.count < 2 { return }
        if let scrollView = scrollViewToResize {
            for var i = inputFields.count - 1; i >= 0; i-- {
                if inputFields.objectAtIndex(i) === activeControl {
                    var nextControl: UIControl
                    if (i == 0) {
                        nextControl = inputFields.objectAtIndex(inputFields.count - 1) as! UIControl
                    } else {
                        nextControl = inputFields.objectAtIndex(i - 1) as! UIControl
                    }
                    
                    UIView.animateWithDuration(0.2, animations:{
                        scrollView.scrollRectToVisible(nextControl.frame, animated: true)
                        }, completion: ({ finished in
                            nextControl.becomeFirstResponder()
                        }))
                    break
                }
            }
        }
    }
    
    func closeKeyboard() {
        activeControl?.resignFirstResponder()
    }
    
    func keyboardDidShow(aNotification: NSNotification) {
        if let scrollView: UIScrollView = scrollViewToResize {
            keyboardShowing = true
            var info: NSDictionary = aNotification.userInfo!
            let s:NSValue = info.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            var kbSize = s.CGRectValue().size
            var viewHeight = view.frame.size.height
            // bug with the notification being the wrong size when in landscape
            if (isLandscape) {
                var kbSizeHeight = min(kbSize.width, kbSize.height)
                var kbSizeWidth = max(kbSize.width, kbSize.height)
                kbSize = CGSizeMake(kbSizeWidth, kbSizeHeight)
                viewHeight = min(view.frame.size.height, view.frame.size.width) // just querying self.view.frame.size.height won't work as it reports a portrait size with a rotation transform applied to the layer
            }
            var distanceOfScrollViewFromBottomOfWindow = max(0, viewHeight - scrollView.frame.origin.y - (scrollView.frame.origin.y + scrollView.frame.size.height))
            var adjustForToolBar = (nil == tabBarController) ? 0 : tabBarController?.tabBar.frame.size.height
            var contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height - scrollView.frame.origin.y - distanceOfScrollViewFromBottomOfWindow - adjustForToolBar!, 0)
            scrollView.scrollIndicatorInsets = contentInsets
            scrollView.contentInset = contentInsets
            
            if let view = activeControl as? UIView {
                var rect = view.frame
                var subs = scrollView.subviews as NSArray
                if !subs.containsObject(activeControl!) {
                    var p = view.convertPoint(view.frame.origin, toView:scrollView)
                    rect = CGRectMake(1, p.y + view.frame.size.height, 1, 1)
                }
                scrollView.scrollRectToVisible(rect, animated: true)
            }
        }
    }
    
    func keyboardWillHide() {
        if let scrollView = scrollViewToResize {
            keyboardShowing = false
            scrollView.contentInset = UIEdgeInsetsZero
            scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if inputFields.containsObject(textField) {
            activeControl = textField
        } else {
            activeControl = nil
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if inputFields.containsObject(textView) {
            activeControl = textView
        } else {
            activeControl = nil
        }
    }
    //END Keyboard did show and resize scrollview
    
    //MARK:- Show activity message
    func showLoadingScreen(message: String) {
        activitySuperview = UIView(frame: view.bounds)
        activitySuperview.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        view.addSubview(activitySuperview)
        let dimmerView = UIView(frame: activitySuperview.bounds)
        dimmerView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        dimmerView.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        dimmerView.alpha = 0.6
        activitySuperview.addSubview(dimmerView)
        let boxEdge: CGFloat = 250.0
        let containerBG = CGRectMake(
            (activitySuperview.bounds.size.width / 2) - (boxEdge / 2),
            (activitySuperview.bounds.height / 2) - (boxEdge / 2), boxEdge, boxEdge)
        
        let containerView = UIView(frame: containerBG)
        containerView.autoresizingMask = .FlexibleTopMargin | .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        containerView.backgroundColor = UIColor.clearColor()
        activitySuperview.addSubview(containerView)
        
        let spinnerEdge: CGFloat = 90
        let spinnerBG = CGRectMake((containerBG.size.width / 2) - (spinnerEdge / 2),
            (containerBG.size.height / 2) - (spinnerEdge / 2), spinnerEdge, spinnerEdge)
        let spinnerBGView = UIView(frame: spinnerBG)
        spinnerBGView.backgroundColor = UIColor(rgba: "34A9DA")
        spinnerBGView.opaque = false
        spinnerBGView.layer.cornerRadius = 45
        containerView.addSubview(spinnerBGView)
        
        if (message.isSane()) {
            let messageLabel = UILabel(frame: CGRectMake(20, spinnerBG.origin.y - 50, containerView.bounds.size.width - 40, 70))
            messageLabel.text = message
            messageLabel.numberOfLines = 1
            messageLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
            messageLabel.shadowColor = UIColor.blackColor()
            messageLabel.shadowOffset = CGSizeMake(0, 1)
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.backgroundColor = UIColor.clearColor()
            messageLabel.textAlignment = .Center
            containerView.addSubview(messageLabel)
        }
        
        let progressFrame = CGRectMake((spinnerBG.size.width / 2) - 25, (spinnerBG.size.height / 2) - 25, 50, 50)
        let progressView = FFCircularProgressView(frame: progressFrame)
        progressView.iconLayer.hidden = true
        progressView.tintColor = UIColor.whiteColor()
        spinnerBGView.addSubview(progressView)
        progressView.startSpinProgressBackgroundLayer()
        
        UIView.beginAnimations("fadeglow", context: nil)
        UIView.setAnimationDuration(1.5)
        UIView.setAnimationRepeatAutoreverses(true)
        UIView.setAnimationRepeatCount(MAXFLOAT)
        spinnerBGView.alpha = 0.8
        UIView.commitAnimations()
        
        activitySuperview.alpha = 0
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: {
            if let strongSelf = weakSelf {
                strongSelf.activitySuperview.alpha = 1
            }
        })
    }
    
    func showLoadingScreen() {
        showLoadingScreen("Loading")
    }
    
    func hideLoadingScreen() {
        activitySuperview.alpha = 1
        weak var weakSelf = self
        
        UIView.animateWithDuration(0.5, animations: {
            if let strongSelf = weakSelf {
                strongSelf.activitySuperview.alpha = 0
            }
        }, completion: { (complete) in
            if let strongSelf = weakSelf {
                strongSelf.activitySuperview.removeFromSuperview()
            }
        })
    }
    //END Show activity message
}