//
//  SeasonViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit
import QuartzCore   

class SeasonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var titleString: String!
    var descriptionString: String!
//    var episodeList: JSONArray = []
//    var episodeArray : JSONEpisodeArray = []
    var imageForSeason: UIImage!
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seasonImage: UIImageView!
    @IBOutlet weak var seasonDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        var titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        var nib = UINib(nibName: "seasonsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        navigationItem.titleView = titleLabel
        seasonDescription.text=descriptionString
//        for obj: AnyObject in episodeList{
//            let episode = Episode.create1 <^>
//                obj["title"]                >>> JSONString <*>
//                obj["description"]          >>> JSONString <*>
//                obj["episode_image_url"]    >>> JSONString <*>
//                obj["viewing_time"]         >>> JSONString <*>
//                obj["episode_id"]           >>> JSONString <*>
//                obj["characters"]           >>> JSONObject
//            episodeArray.append(episode!)
//        }
        self.seasonDescription.scrollRangeToVisible(NSMakeRange(0,0))
        self.seasonImage.image = imageForSeason
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return /*self.episodeArray.count*/0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("episodeCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = /*self.episodeArray[indexPath.section].name */ "THIS RIGHT HERE"
//        var cell:SeasonsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! SeasonsTableViewCell
//        cell.seasonTitle.text = self.episodeArray[indexPath.section].name
//        cell.seasonDescription.text = self.episodeArray[indexPath.section].description
//        cell.seasonImage.image = nil
//        
//        var urlString = self.episodeArray[indexPath.section].episodeImage
//        if let img = imageCache[urlString]{
//            cell.imageView?.image = img
//        }else{
//            let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
//            getPreSignedURLRequest.bucket = S3BucketName
//            getPreSignedURLRequest.key = urlString
//            getPreSignedURLRequest.HTTPMethod = AWSHTTPMethod.GET
//            getPreSignedURLRequest.expires = NSDate(timeIntervalSinceNow: 3600)
//            
//            //check if URL is in array, if not then perform async request to get the urls set url string outside of this block
//            AWSS3PreSignedURLBuilder.defaultS3PreSignedURLBuilder().getPreSignedURL(getPreSignedURLRequest) .continueWithBlock { (task:BFTask!) -> (AnyObject!) in
//                if (task.error != nil) {
//                    NSLog("Error: %@", task.error)
//                } else {
//                    let presignedURL = task.result as! NSURL!
//                    if (presignedURL != nil) {
//                        NSLog("download presignedURL is: \n%@", presignedURL)
//                        let mainQueue = NSOperationQueue.mainQueue()
//                        let request = NSURLRequest(URL: presignedURL)
//                        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
//                            if error == nil {
//                                // Convert the downloaded data in to a UIImage object
//                                let image = UIImage(data: data)
//                                // Store the image in to our cache, if it is missing set it to the show image
//                                if urlString.rangeOfString("missing.png") != nil {
//                                    self.imageCache[urlString] = self.seasonImage.image
//                                }else{
//                                    self.imageCache[urlString] = image
//                                }
//                                // Update the cell
//                                dispatch_async(dispatch_get_main_queue(), {
//                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
//                                        cellToUpdate.imageView?.image = image
//                                        self.tableView.reloadData()
//                                    }
//                                })
//                            }
//                            else {
//                                println("Error: \(error.localizedDescription)")
//                            }
//                        })
//                    }
//                }
//                return nil;
//            }
//        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("episodeSegue", sender: cell)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
//        if segue.identifier == "episodeSegue"{
//            if let navbar = segue.destinationViewController as? UINavigationController{
//                if let destinationVC = navbar.topViewController as? EpisodeViewController{
//                    let indexPath = self.tableView?.indexPathForCell(sender as! SeasonsTableViewCell)
//                    let sectionId = indexPath!.section
//                    destinationVC.titleString = self.episodeArray[sectionId].name
//                    destinationVC.descriptionString = self.episodeArray[sectionId].description
//                    destinationVC.characterList = self.episodeArray[sectionId].characters
//                    destinationVC.imageForEpisode = self.imageCache[self.episodeArray[sectionId].episodeImage]
//                    destinationVC.episodeId = self.episodeArray[sectionId].episodeId
//                }
//            }else{
//                print("error")
//            }
//        }
    }
}
