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
    var characterList: JSONArray = []
    var characterArray : JSONCharacterArray = []
    var imageForEpisode: UIImage!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        let titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        let nib = UINib(nibName: "showsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        navigationItem.titleView = titleLabel
        self.episodeDescription.scrollRangeToVisible(NSMakeRange(0,0))
        episodeDescription.text=descriptionString
        for obj: AnyObject in characterList{
            characterArray.append(Character(json: obj as! NSDictionary))
        }
        
        self.episodeDescription.scrollRangeToVisible(NSMakeRange(0,0))
        self.episodeImage.image = imageForEpisode
    }
    
    //called when the view has just finished laying out, all view should be in the correct places/frames
    override func viewDidLayoutSubviews() {
        //ensures that the episodeDescription is scrolled to the top upon loading
        self.episodeDescription.contentOffset = CGPointZero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.characterArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AllShowsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! AllShowsTableViewCell
        cell.showTitle.text = self.characterArray[indexPath.section].firstName! + ", " + self.characterArray[indexPath.section].lastName!
        cell.showCharacters.text = "Played by: " + self.characterArray[indexPath.section].actor!
        cell.showImage.image = nil
        
        let urlString = self.characterArray[indexPath.section].characterImageURL!
        if let img = GlobalVariables.imageCache[urlString]{
            cell.showImage.image = img
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
                        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
                            if error == nil {
                                // Convert the downloaded data in to a UIImage object
                                let image = UIImage(data: data!)
                                // Store the image in to our cache, if it is missing set it to the show image
                                if urlString.rangeOfString("missing.png") != nil {
                                    GlobalVariables.imageCache[urlString] = self.episodeImage.image
                                }else{
                                    GlobalVariables.imageCache[urlString] = image
                                }
                                // Update the cell
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! AllShowsTableViewCell?{
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
        if segue.identifier == "characterSegue"{
            if let destinationVC = segue.destinationViewController as? CharactersViewController{
                let indexPath = self.tableView?.indexPathForCell(sender as! AllShowsTableViewCell)
                let sectionId = indexPath!.section
                destinationVC.titleString = self.characterArray[sectionId].firstName! + " " + self.characterArray[sectionId].lastName!
                destinationVC.descriptionString = self.characterArray[sectionId].description
                destinationVC.outfitList = self.characterArray[sectionId].outfitList!
                destinationVC.imageForCharacter = GlobalVariables.imageCache[self.characterArray[sectionId].characterImageURL!]
                destinationVC.currentEpisode = self.episodeId
            }
        }
    }
}
