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
                if let realError = error {
                    var alertView = UIAlertView(title: "Whoops", message: realError.localizedDescription, delegate: self, cancelButtonTitle: "OK")
                    alertView.show()
                    return
                }
                
                strongSelf.hideLoadingScreen()
                strongSelf.reloadData()
            }
        }
        searchCommand.commandCompletionBlock = completionBlock
        showLoadingScreen()
        GlobalCommandRunner.executeCommand(searchCommand)
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        var rows = GlobalModel.currentBook != nil ? 4 : 0
        return rows
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var book = GlobalModel.currentBook!
        var cell: Cell = tableView.dequeueReusableCellWithIdentifier(kCellId, forIndexPath: indexPath) as Cell
        switch indexPath.row {
        case 0:
            cell.textBox.text = book.title
        case 1:
            cell.textBox.text = "\(book.price)"
        case 2:
            cell.textBox.text = book.author!.name
        default:
            cell.textBox.text = book.blurb
        }
        return cell
    }

}