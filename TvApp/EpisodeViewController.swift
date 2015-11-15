//
//  EpisodeViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/15/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit
import QuartzCore

class EpisodeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var titleString: String!
    var descriptionString: String!
    var episodeId: String!
//    var characterList: JSONArray = []
//    var characterArray : JSONCharacterArray = []
    var imageForEpisode: UIImage!
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        var titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        var nib = UINib(nibName: "showsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        navigationItem.titleView = titleLabel
        episodeDescription.text=descriptionString
//        for obj: AnyObject in characterList{
//            let character = Character.create <^>
//                obj["first_name"]      >>> JSONString <*>
//                obj["last_name"]       >>> JSONString <*>
//                obj["outfits"]         >>> JSONObject <*>
//                obj["joins_ids"]       >>> JSONObject <*>
//                obj["character_image_url"] >>> JSONString
//            characterArray.append(character!)
//        }
        self.episodeDescription.scrollRangeToVisible(NSMakeRange(0,0))
        self.episodeImage.image = imageForEpisode
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return /*self.characterArray.count*/ 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:AllShowsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! AllShowsTableViewCell
        cell.showTitle.text = /*self.characterArray[indexPath.section].firstName + ", " + self.characterArray[indexPath.section].lastName*/ "ALMOST THERE..."
        cell.showImage.image = nil
        
//        var urlString = self.characterArray[indexPath.section].characterImage
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
//                                    self.imageCache[urlString] = self.episodeImage.image
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
//        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("characterSegue", sender: cell)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
//        if segue.identifier == "characterSegue"{
//            if let navbar = segue.destinationViewController as? UINavigationController{
//                if let destinationVC = navbar.topViewController as? CharactersViewController{
//                    let indexPath = self.tableView?.indexPathForCell(sender as! AllShowsTableViewCell)
//                    let sectionId = indexPath!.section
//                    destinationVC.titleString = self.characterArray[sectionId].firstName + " " + self.characterArray[sectionId].lastName
//                    destinationVC.descriptionString = "add another image or description"
//                    destinationVC.outfitList = self.characterArray[sectionId].outfitList
//                    destinationVC.imageForCharacter = self.imageCache[self.characterArray[sectionId].characterImage]
//                    destinationVC.currentEpisode = self.episodeId
//                }
//            }else{
//                print("error")
//            }
//        }
    }
}
