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
    var episodeList: JSONArray = []
    var episodeArray : JSONEpisodeArray = []
    var imageForSeason: UIImage!
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seasonImage: UIImageView!
    @IBOutlet weak var seasonDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        let titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        let nib = UINib(nibName: "seasonsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        navigationItem.titleView = titleLabel
        seasonDescription.text=descriptionString
        for obj: AnyObject in episodeList {
            episodeArray.append(Episode(json: obj as! NSDictionary))
        }
        self.seasonImage.image = imageForSeason
    }
    
    //called when the view has just finished laying out, all view should be in the correct places/frames
    override func viewDidLayoutSubviews() {
        //ensures that the episodeDescription is scrolled to the top upon loading
        self.seasonDescription.contentOffset = CGPointZero
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.seasonDescription.scrollEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.episodeArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SeasonsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! SeasonsTableViewCell
        cell.seasonTitle.text = self.episodeArray[indexPath.section].title
        cell.seasonDescription.text = self.episodeArray[indexPath.section].description
        cell.seasonImage.image = nil

        let urlString = self.episodeArray[indexPath.section].episodeImageURL!
        if let img = imageCache[urlString]{
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
                        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in                            if error == nil {
                                // Convert the downloaded data in to a UIImage object
                                let image = UIImage(data: data!)
                                // Store the image in to our cache, if it is missing set it to the show image
                                if urlString.rangeOfString("missing.png") != nil {
                                    self.imageCache[urlString] = self.seasonImage.image
                                }else{
                                    self.imageCache[urlString] = image
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
        performSegueWithIdentifier("episodeSegue", sender: cell)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "episodeSegue"{
            if let destinationVC = segue.destinationViewController as? EpisodeViewController{
                let indexPath = self.tableView?.indexPathForCell(sender as! SeasonsTableViewCell)
                let sectionId = indexPath!.section
                destinationVC.titleString = self.episodeArray[sectionId].title
                destinationVC.descriptionString = self.episodeArray[sectionId].description
                destinationVC.characterList = self.episodeArray[sectionId].characters!
                destinationVC.imageForEpisode = self.imageCache[self.episodeArray[sectionId].episodeImageURL!]
                destinationVC.episodeId = self.episodeArray[sectionId].episodeId
            }
        }
    }
}
