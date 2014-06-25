//
//  TSTableViewController.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 25/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class TSTableViewController: TSViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView
    
    override func viewDidLoad()  {
        scrollViewToResize = tableView
        super.viewDidLoad()
    }
    
    override func reloadData() {
        tableView.reloadData()
        super.reloadData()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 28
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: Cell = tableView.dequeueReusableCellWithIdentifier(kCellId) as Cell
        cell.textLabel.text = "cell \(indexPath.row)"
        return cell
    }
    
    override func wantsPullToRefresh() -> Bool {
        return true
    }
    
    override func wantsPullToRefreshFooter() -> Bool {
        return true
    }
}