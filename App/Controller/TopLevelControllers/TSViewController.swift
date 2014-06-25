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
    
    @IBOutlet var tf1: UITextField
    @IBOutlet var tf2: UITextField
    @IBOutlet var tf3: UITextField
    // todo: move the above IBOutlets to the DemoViewController, as soon as XCode lets you hook up an IBOutlet from a parent class (this) to a subclass (DemoViewController)
    @IBOutlet var scrollViewToResize: UIScrollView?
    var inputFields = NSArray()
    var activitySuperview = UIView() //for the show message function
    var headerView: TSPullView?
    var footerView: TSPullView?
    var fetchingData = false
    weak var activeControl: UIResponder?
    
    override func viewDidLoad() {
        self.inputFields = [tf1, tf2, tf3]
        
        self.automaticallyAdjustsScrollViewInsets = false
        if self.inputFields.count > 0 {
            var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
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
            
            for control : AnyObject in self.inputFields {
                if control.isKindOfClass(UITextView.self) {
                    let tv = control as UITextView
                    tv.inputAccessoryView = toolbar
                } else if control.isKindOfClass(UITextField.self) {
                    let tf = control as UITextField
                    tf.inputAccessoryView = toolbar
                }
            }
            
            if let scrollView: UIScrollView = self.scrollViewToResize {
                scrollView.contentInset = UIEdgeInsetsZero
                scrollView.contentSize = scrollView.frame.size
                
                if wantsPullToRefresh() {
                    let headerFrame = CGRectMake(0, -600, scrollView.bounds.size.width, 600)
                    headerView = TSPullView(frame: headerFrame, isForBottomOfView: false)
                    headerView!.delegate = self
                    scrollView.addSubview(headerView)
                }
                
                if wantsPullToRefreshFooter() {
                    let footerFrame = CGRectMake(0, scrollView.bounds.size.height, scrollView.bounds.size.width, 600)
                    footerView = TSPullView(frame: footerFrame, isForBottomOfView: true)
                    footerView!.delegate = self
                    scrollView.addSubview(footerView)
                }
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
            }
        }
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if self.respondsToSelector("specialLayout") {
            self.specialLayout()
        }
        if wantsPullToRefreshFooter() {
            setupFooterView()
        }
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        if nil != self.scrollViewToResize {
            NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: UIKeyboardDidShowNotification)
            NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: UIKeyboardWillHideNotification)
        }
    }
    
    // TSPullView
    func TSPullDidTriggerRefresh(view: TSPullView) {
        self.fetchData()
        self.pullDownAction()
    }
    
    func TSPullDidTriggerLoadMore(view: TSPullView) {
        self.fetchData()
        self.pullUpAction()
    }
    
    func TSPullDelegateIsLoadingData() -> Bool {
        return fetchingData
    }
    
    func TSPullViewLastUpdated(pullView: TSPullView) -> NSDate {
        return NSDate()
    }
    
    func pullDownAction() {
        self.showActivityScreen()
        weak var weakSelf = self
        
        delay(2.5) {
            if let strongSelf = weakSelf {
                strongSelf.hideActivityScreen()
                strongSelf.doneLoadingData()
            }
        }
    }
    
    func pullUpAction() {
        self.showActivityScreen()
        weak var weakSelf = self
        
        delay(2.5) {
            if let strongSelf = weakSelf {
                strongSelf.hideActivityScreen()
                strongSelf.doneLoadingData()
            }
        }
    }
    //END TSPullView
    
    //ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        var currentOffset = scrollView.contentOffset.y
        var maximumOffset = max(scrollView.contentSize.height - scrollView.frame.size.height, 0)
        if currentOffset < 0 {
            if wantsPullToRefresh() {
                headerView!.scrollViewDidScroll(scrollView)
            }
        } else if currentOffset > maximumOffset {
            if wantsPullToRefreshFooter() {
                footerView!.scrollViewDidScroll(scrollView)
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        var currentOffset = scrollView.contentOffset.y
        var maximumOffset = max(scrollView.contentSize.height - scrollView.frame.size.height, 0)
        if currentOffset < 0 {
            if wantsPullToRefresh() {
                headerView!.scrollViewDidEndDragging(scrollView)
            }
        } else if currentOffset > maximumOffset {
            if wantsPullToRefreshFooter() {
                footerView!.scrollViewDidEndDragging(scrollView)
            }
        }
    }
    //END ScrollViewDelegate
    
    //Pull To Refresh and Load data
    func wantsPullToRefresh() -> Bool {
        return true
    }
    
    func wantsPullToRefreshFooter() -> Bool {
        return true
    }
    
    func fetchData() {
        self.fetchingData = true
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
        
        if wantsPullToRefresh() {
            weak var weakSelf = self
            delay(0.5) {
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
    
    //Autolayout + UIScrollView madness
    func specialLayout() {
        if let scrollView = self.scrollViewToResize {
            if scrollView.contentSize.height < scrollView.bounds.size.height {
                scrollView.contentSize = self.scrollViewContentSize()
                scrollView.contentSize.height += 500
            }
        }
    }
    
    func scrollViewContentSize() -> CGSize {
        if let scrollView = self.scrollViewToResize {
            return scrollView.bounds.size
        }
        return CGSizeZero
    }
    //END Autolayout + UIScrollView madness
    
    // Keyboard did show and resize scrollview
    func nextPrevChanged(sender: AnyObject) {
        if let segControl: UISegmentedControl = sender as? UISegmentedControl {
            switch segControl.selectedSegmentIndex {
            case 0:
                self.prevInput()
            case 1:
                self.nextInput()
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
                        nextControl = inputFields.objectAtIndex(i+1) as UIControl
                    } else {
                        nextControl = inputFields.objectAtIndex(0) as UIControl
                    }
                    
                    UIView.animateWithDuration(0.2, animations:{
                        scrollView.scrollRectToVisible(nextControl.frame, animated: true)
                        }, completion: ({ finished in
                            var n = nextControl.becomeFirstResponder() // are you fucking kidding me Swift? becomeFirstResponser returns a bool, so unless I capture this in a variable the parser will think I'm trying to return Bool from this block (and won't compile)
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
                        nextControl = inputFields.objectAtIndex(inputFields.count - 1) as UIControl
                    } else {
                        nextControl = inputFields.objectAtIndex(i - 1) as UIControl
                    }
                    
                    UIView.animateWithDuration(0.2, animations:{
                        scrollView.scrollRectToVisible(nextControl.frame, animated: true)
                        }, completion: ({ finished in
                            var n = nextControl.becomeFirstResponder() // are you fucking kidding me Swift? becomeFirstResponser returns a bool, so unless I capture this in a variable the parser will think I'm trying to return Bool from this block (and won't compile)
                        }))
                    break
                }
            }
        }
    }
    
    func closeKeyboard() {
        self.activeControl?.resignFirstResponder()
    }
    
    func keyboardDidShow(aNotification: NSNotification) {
        if let scrollView: UIScrollView = scrollViewToResize {
            var info: NSDictionary = aNotification.userInfo
            var kbSize: CGSize = info.objectForKey(UIKeyboardFrameEndUserInfoKey).CGRectValue().size
            var viewHeight = self.view.frame.size.height
            // bug with the notification being the wrong size when in landscape
            if (isLandscape) {
                var kbSizeHeight = min(kbSize.width, kbSize.height)
                var kbSizeWidth = max(kbSize.width, kbSize.height)
                kbSize = CGSizeMake(kbSizeWidth, kbSizeHeight)
                viewHeight = min(self.view.frame.size.height, self.view.frame.size.width) // just querying self.view.frame.size.height won't work as it reports a portrait size with a rotation transform applied to the layer
            }
            var distanceOfScrollViewFromBottomOfWindow = max(0, viewHeight - scrollView.frame.origin.y - (scrollView.frame.origin.y + scrollView.frame.size.height))
            var adjustForToolBar = (nil == self.tabBarController) ? 0 : self.tabBarController?.tabBar.frame.size.height
            var contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height - scrollView.frame.origin.y - distanceOfScrollViewFromBottomOfWindow - adjustForToolBar!, 0)
            scrollView.scrollIndicatorInsets = contentInsets
            scrollView.contentInset = contentInsets
            
            if let view = activeControl as? UIView {
                var rect = view.frame
                var subs = scrollView.subviews as NSArray
                if !subs.containsObject(activeControl) {
                    var p = view.convertPoint(view.frame.origin, toView:scrollView)
                    rect = CGRectMake(1, p.y + view.frame.size.height, 1, 1)
                }
                scrollView.scrollRectToVisible(rect, animated: true)
            }
        }
    }
    
    func keyboardWillHide() {
        if let scrollView = scrollViewToResize {
            scrollView.contentInset = UIEdgeInsetsZero
            scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        if inputFields.containsObject(textField) {
            activeControl = textField
        } else {
            activeControl = nil
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView!) {
        if inputFields.containsObject(textView) {
            activeControl = textView
        } else {
            activeControl = nil
        }
    }
    //END Keyboard did show and resize scrollview
    
    //Show activity message
    func showActivityScreen(message: String) {
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
        spinnerBGView.backgroundColor = ColorWithHexString("34A9DA")
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
    
    func showActivityScreen() {
        showActivityScreen("Loading")
    }
    
    func hideActivityScreen() {
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