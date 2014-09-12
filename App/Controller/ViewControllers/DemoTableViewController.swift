//
//  DemoTableViewController.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 14/07/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class DemoTableViewController: TSTableViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var searchCommand = iTunesSearchCommand()
        weak var weakSelf = self
        let completionBlock: commandCompletionBlock = { (error) in
            if let strongSelf = weakSelf {
                strongSelf.hideLoadingScreen()
                if let realError = error {
                    var alertView = UIAlertView(title: "Whoops", message: realError.localizedDescription, delegate: strongSelf, cancelButtonTitle: "OK")
                    alertView.show()
                    return
                }
                
                strongSelf.reloadData()
            }
        }
        searchCommand.commandCompletionBlock = completionBlock
        showLoadingScreen()
        GlobalCommandRunner.executeCommand(searchCommand)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = book() != nil ? 4 : 0
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: Cell = tableView.dequeueReusableCellWithIdentifier(kCellId, forIndexPath: indexPath) as Cell
        if let book = book() {
            switch indexPath.row {
            case 0:
                cell.textBox!.text = book.title
            case 1:
                cell.textBox!.text = "\(book.price)"
            case 2:
                cell.textBox!.text = book.author.name
            default:
                cell.textBox!.text = book.blurb
            }
        }
        return cell
    }

    //helpers
    func book() -> Book? {
        return GlobalModel.currentBook?
    }
    
    @IBAction func dismissTouched(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}