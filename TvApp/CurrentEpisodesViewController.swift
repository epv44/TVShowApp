//
//  CurrentShowsViewController.swift
//  TvApp
//  Shows load back three hours, to account for pacific timezone, should maybe go back 4 hours or when more shows are added adjust for different timezones
//  especially if outside of the USA.
//  Created by Eric Vennaro on 4/13/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class CurrentEpisodesViewController: UITableViewController {
    private var episodeArray : JSONEpisodeArray = []
    let tableHeaderHeight: CGFloat = 75.0
    var headerView: UIView!
    var emptyTitleLabel: UILabel!
    var emptyTextView: UITextView!
    var noCurrentShows = false
    
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
        let nib = UINib(nibName: "currentEpisodesTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        //populate view with all shows
        let progressIndicatorView = UIProgressView(frame: CGRect(x: 0.0, y: 80.0, width: self.view.bounds.width, height: 10.0))
        progressIndicatorView.tintColor = GreenBackgroundFromHex()
        self.view.addSubview(progressIndicatorView)
        
        progressIndicatorView.setProgress(80.0 / 100.0, animated: true)
        progressIndicatorView.removeFromSuperview()

        //need to error check & then output data correctly for nested JSON
        getCurrentEpisodes { (currentEpisodes) -> () in
            self.processResults(currentEpisodes)
            progressIndicatorView.removeFromSuperview()
        }
    }
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    func displayError(){
        emptyTitleLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 100))
        //titleLabel.center = CGPointMake(160, 284)
        emptyTitleLabel.textAlignment = NSTextAlignment.Center
        emptyTitleLabel.font = UIFont(name: "AvantGarde LT Book", size: 30)
        emptyTitleLabel.text = "Bummer..."
        emptyTextView = UITextView(frame: CGRectMake(0,105,self.view.bounds.width,200))
        emptyTextView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        emptyTextView.textAlignment = NSTextAlignment.Center
        emptyTextView.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        emptyTextView.text = "Looks like there are no episodes currently playing in your area.  Feel free to check back later or browse all of our shows!"
        emptyTextView.editable = false
        self.view.addSubview(emptyTitleLabel)
        self.view.addSubview(emptyTextView)
        noCurrentShows = true
    }
    func removeError(){
        self.emptyTitleLabel.removeFromSuperview()
        self.emptyTextView.removeFromSuperview()
    }
    
    func processResults(array: JSONEpisodeArray){
        self.episodeArray = array
        if(noCurrentShows && episodeArray.count > 0) {
            removeError()
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 7
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.episodeArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CurrentEpisodeViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! CurrentEpisodeViewCell
        cell.episodeTitle.text = self.episodeArray[indexPath.section].title
        cell.episodeDescription.text = self.episodeArray[indexPath.section].description
        
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
