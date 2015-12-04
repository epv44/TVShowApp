//
//  AllShowsViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/13/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class AllShowsViewController: UITableViewController {
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
        let nib = UINib(nibName: "showsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        //populate view with all shows
        let progressIndicatorView = UIProgressView(frame: CGRect(x: 0.0, y: 80.0, width: self.view.bounds.width, height: 10.0))
        progressIndicatorView.tintColor = GreenBackgroundFromHex()
        self.view.addSubview(progressIndicatorView)
        
        progressIndicatorView.setProgress(80.0 / 100.0, animated: true)

        getAllShows { (allShows) -> () in
            self.processResults(allShows)
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
    
    func processResults(array: JSONShowArray){
        self.showArray = array
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = GreenBackgroundFromHex()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
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
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("showSegue", sender: cell)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AllShowsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! AllShowsTableViewCell
        cell.showTitle.text = self.showArray[indexPath.section].title!
        cell.showCharacters.text = self.showArray[indexPath.section].mainCharacters!
        cell.showImage.image = nil
        
        let urlString = self.showArray[indexPath.section].showImageURL!
        if let img = GlobalVariables.imageCache[urlString]{
           cell.showImage.image = img
        }else{
            let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
            getPreSignedURLRequest.bucket = S3BucketName
            getPreSignedURLRequest.key = urlString
            getPreSignedURLRequest.HTTPMethod = AWSHTTPMethod.GET
            getPreSignedURLRequest.expires = NSDate(timeIntervalSinceNow: 3600)
            
            //check if URL is in array, if not then perform async request to get the urls set url string outside of this block
            
            AWSS3PreSignedURLBuilder.defaultS3PreSignedURLBuilder().getPreSignedURL(getPreSignedURLRequest).continueWithBlock { (task:AWSTask!) -> (AnyObject!) in
                if (task.error != nil) {
                    NSLog("Error: %@", task.error)
                } else {
                    let presignedURL = task.result as! NSURL!
                    if (presignedURL != nil) {
                        NSLog("download presignedURL is: \n%@", presignedURL)
                        let request = NSURLRequest(URL: presignedURL)
                        
                        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                            if error == nil {
                                // Convert the downloaded data in to a UIImage object
                                let image = UIImage(data: data!)
                                // Store the image in to our cache, if it is missing set it to the default image -- need a default image
                                if urlString.rangeOfString("missing.png") != nil {
                                    GlobalVariables.imageCache[urlString] = UIImage(named: "ArrowRight.png")
                                }else{
                                    GlobalVariables.imageCache[urlString] = image
                                }
                                // Update the cell
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! AllShowsTableViewCell? {
                                        cellToUpdate.showImage.image = image
                                        self.tableView.reloadData()
                                    }
                                })
                            }
                            else {
                                print("Error: \(error!.localizedDescription)")
                            }
                        })
                        task.resume()
                    }
                }
                return nil;
            }
        }
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSegue"{
            if let destinationVC = segue.destinationViewController as? ShowViewController{
                let indexPath = self.tableView?.indexPathForCell(sender as! AllShowsTableViewCell)
                let sectionId = indexPath!.section
                destinationVC.titleString = self.showArray[sectionId].title
                destinationVC.descriptionString = self.showArray[sectionId].description
                destinationVC.seasonList = self.showArray[sectionId].seasons!
                destinationVC.imageUrl = self.showArray[sectionId].showImageURL
                destinationVC.showImage = GlobalVariables.imageCache[self.showArray[sectionId].showImageURL!]
            }
        }
    }
}
