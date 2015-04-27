//
//  AllShowsViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/13/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class AllShowsViewController: UITableViewController, UIScrollViewDelegate {
    
    private var showArray : JSONShowArray = []
    let tableHeaderHeight: CGFloat = 75.0
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set background color
        self.view.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        
        //set header image
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        updateHeaderView()
        //set table cell
        var nib = UINib(nibName: "showsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        //populate view with all shows
        let progressIndicatorView = UIProgressView(frame: CGRect(x: 0.0, y: 80.0, width: self.view.bounds.width, height: 10.0))
        progressIndicatorView.tintColor = UIColorFromHex(0x61edaf, alpha: 1)
        self.view.addSubview(progressIndicatorView)
        
        progressIndicatorView.setProgress(80.0 / 100.0, animated: true)
        getAllShows() { either in
            switch either {
            case let .Error(error):
                //                let httpHelper = HTTPHelper()
                //                let errorMessage = httpHelper.getErrorMessage(error)
                let errorAlert = UIAlertView(title: "Error", message:"Error", delegate:nil, cancelButtonTitle:"OK")
                progressIndicatorView.removeFromSuperview()
                errorAlert.show()
            case let .Value(boxedAllShows):
                progressIndicatorView.removeFromSuperview()
                self.processResults(boxedAllShows.value)
                
            }
        }
        
    }
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
    func processResults(array: JSONShowArray){
        self.showArray = array
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return self.showArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCellWithIdentifier("allShows", forIndexPath: indexPath) as UITableViewCell
        //        cell.textLabel?.text = self.showArray[indexPath.row].name
        var cell:AllShowsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as AllShowsTableViewCell
        cell.showTitle.text = self.showArray[indexPath.section].name
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
