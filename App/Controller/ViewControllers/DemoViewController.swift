//
//  DemoViewController.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 9/07/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import UIKit

class DemoViewController: TSViewController {
    @IBOutlet var tf1: UITextField
    @IBOutlet var tf2: UITextField
    @IBOutlet var tf3: UITextField
    
    override func viewDidLoad()  {
        if tf1 { inputFields.addObject(tf1) }
        if tf2 { inputFields.addObject(tf2) }
        if tf3 { inputFields.addObject(tf3) }
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func wantsPullToRefresh() -> Bool {
        return true
    }
    
    override func wantsPullToRefreshFooter() -> Bool {
        return true
    }
}
