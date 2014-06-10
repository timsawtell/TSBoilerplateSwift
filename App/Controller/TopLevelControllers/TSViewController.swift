//
//  TSViewController.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 4/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation
import UIKit

class TSViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var tf1 : UITextField
    @IBOutlet var tf2 : UITextField
    @IBOutlet var tf3 : UITextField
    // todo: move the above IBOutlets to the DemoViewController, as soon as XCode lets you hook up an IBOutlet from a parent class (this) to a subclass (DemoViewController)
    @IBOutlet var scrollViewToResize : UIScrollView?
    var inputFields = NSArray()
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
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        if nil != self.scrollViewToResize {
            NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: UIKeyboardDidShowNotification)
            NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: UIKeyboardWillHideNotification)
        }
    }
    
    func specialLayout() {
        if let scrollView = self.scrollViewToResize {
            if scrollView.contentSize.height < scrollView.bounds.size.height {
                scrollView.contentSize = self.scrollViewContentSize()
            }
        }
    }
    
    func scrollViewContentSize() -> CGSize {
        if let scrollView = self.scrollViewToResize {
            return scrollView.bounds.size
        }
        return CGSizeZero
    }
    
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
}