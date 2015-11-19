//
//  ShowViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/28/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit
import QuartzCore

class ShowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showDescription: UITextView!
    var titleString: String!
    var descriptionString: String!
    var imageUrl: String!
    var showImage: UIImage!
    var seasonList: JSONArray = []
    var seasonArray : JSONSeasonArray = []
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    var downloadTask: NSURLSessionDownloadTask?
    var session: NSURLSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        struct Static {
            static var session: NSURLSession?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(BackgroundSessionDownloadIdentifier)
            Static.session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        }
        self.session = Static.session;
        let nib = UINib(nibName: "seasonsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)

        showDescription.text = descriptionString
        
        for obj: AnyObject in seasonList {
            seasonArray.append(Season(json: obj as! NSDictionary))
        }
        self.imageView.image = showImage
        self.showDescription.scrollRangeToVisible(NSMakeRange(0,0))
        if let img = imageCache[imageUrl]{
            self.imageView.image = img
        }else{
            startDownload()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        let titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        navigationItem.titleView = titleLabel
    }
    
    func startDownload(){
        
        if (self.downloadTask != nil) {
            return;
        }
        
        self.imageView.image = nil;
        
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket = S3BucketName
        getPreSignedURLRequest.key = imageUrl
        getPreSignedURLRequest.HTTPMethod = AWSHTTPMethod.GET
        getPreSignedURLRequest.expires = NSDate(timeIntervalSinceNow: 3600)
        
        
        AWSS3PreSignedURLBuilder.defaultS3PreSignedURLBuilder().getPreSignedURL(getPreSignedURLRequest) .continueWithBlock { (task:AWSTask!) -> (AnyObject!) in
            if (task.error != nil) {
                NSLog("Error: %@", task.error)
            } else {
                
                let presignedURL = task.result as! NSURL!
                if (presignedURL != nil) {
                    NSLog("download presignedURL is: \n%@", presignedURL)
                    
                    let request = NSURLRequest(URL: presignedURL)
                    self.downloadTask = self.session?.downloadTaskWithRequest(request)
                    self.downloadTask?.resume()
                }
            }
            return nil;
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        NSLog("DownloadTask progress: %lf", progress)
        
        dispatch_async(dispatch_get_main_queue()) {
            print("Downloading...")
        }
        
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
       // NSLog("[%@ %@]", reflect(self).summary, __FUNCTION__)
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsPath = paths.first! as String
        let fileName = getImageNameFromUrl(imageUrl)
        
        let filePath = documentsPath + fileName
        
        //move the downloaded file to docs directory
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filePath)
            } catch _ {
            }
        }
        
        do {
            try NSFileManager.defaultManager().moveItemAtURL(location, toURL: NSURL.fileURLWithPath(filePath))
        } catch _ {
        }
        
        
        //update UI elements
        dispatch_async(dispatch_get_main_queue()) {
            self.imageCache[self.imageUrl] = UIImage(contentsOfFile: filePath)
            self.imageView.image = UIImage(contentsOfFile: filePath)
        }
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue()) {
                print("Download Successfully")
            }
            NSLog("S3 DownloadTask: %@ completed successfully", task);
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                print("Download Failed")
            }
            NSLog("S3 DownloadTask: %@ completed with error: %@", task, error!.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            //self.progressView.progress = Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
        }
        self.downloadTask = nil
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if ((appDelegate.backgroundDownloadSessionCompletionHandler) != nil) {
            let completionHandler:() = appDelegate.backgroundDownloadSessionCompletionHandler!;
            appDelegate.backgroundDownloadSessionCompletionHandler = nil
            completionHandler
        }
        
        NSLog("Completion Handler has been invoked, background download task has finished.");
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return self.seasonArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SeasonsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! SeasonsTableViewCell
        cell.seasonTitle.text = self.seasonArray[indexPath.section].title
        cell.seasonDescription.text = self.seasonArray[indexPath.section].description
        cell.seasonImage.image = nil
        
        let urlString = self.seasonArray[indexPath.section].seasonImageURL
        if let img = imageCache[urlString!]{
            cell.seasonImage.image = img
        }else{
            let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
            getPreSignedURLRequest.bucket = S3BucketName
            getPreSignedURLRequest.key = urlString
            getPreSignedURLRequest.HTTPMethod = AWSHTTPMethod.GET
            getPreSignedURLRequest.expires = NSDate(timeIntervalSinceNow: 3600)
            
            //check if URL is in array, if not then perform async request to get the urls set url string outside of this block
            AWSS3PreSignedURLBuilder.defaultS3PreSignedURLBuilder().getPreSignedURL(getPreSignedURLRequest) .continueWithBlock { (task:AWSTask!) -> (AnyObject!) in
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
                                // Store the image in to our cache, if it is missing set it to the show image
                                if urlString!.rangeOfString("missing.png") != nil {
                                    self.imageCache[urlString!] = self.imageView.image
                                }else{
                                    self.imageCache[urlString!] = image
                                }
                                // Update the cell
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! SeasonsTableViewCell?{
                                        cellToUpdate.seasonImage.image = image
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("seasonSegue", sender: cell)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "seasonSegue"{
            if let navbar = segue.destinationViewController as? UINavigationController{
                if let destinationVC = navbar.topViewController as? SeasonViewController{
                    let indexPath = self.tableView?.indexPathForCell(sender as! SeasonsTableViewCell)
                    let sectionId = indexPath!.section
                    destinationVC.titleString = self.seasonArray[sectionId].title
                    destinationVC.descriptionString = self.seasonArray[sectionId].description
//                    destinationVC.episodeList = self.seasonArray[sectionId].episodes
//                    destinationVC.imageForSeason = self.imageCache[self.seasonArray[sectionId].seasonImage]
                }
            }else{
                print("error")
            }
        }
    }
}
