//
//  CharactersViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var titleString: String!
    var descriptionString: String!
    var outfitList: JSONArray = []
    var outfitArray : JSONOutfitArray = []
    var currentEpisode: String!
    var imageForCharacter: UIImage!
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterDescription: UITextView!
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
        //outfit list
        self.characterDescription.text = descriptionString
        self.characterImage.image = imageForCharacter
        for obj: AnyObject in outfitList {
            outfitArray.append(Outfit(json: obj as! NSDictionary))
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.outfitArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    //switch to outfit
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AllShowsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! AllShowsTableViewCell
        cell.showTitle.text = self.outfitArray[indexPath.section].outfitName
        cell.showCharacters.text = "Classic summer suit with a twist"
        cell.showImage.image = nil
        
        let urlString = self.outfitArray[indexPath.section].outfitImageURL!
        if let img = imageCache[urlString]{
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
                                    self.imageCache[urlString] = self.characterImage.image
                                }else{
                                    self.imageCache[urlString] = image
                                }
                                // Update the cell
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                                        cellToUpdate.imageView?.image = image
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
        performSegueWithIdentifier("outfitSegue", sender: cell)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "outfitSegue"{
            if let destinationVC = segue.destinationViewController as? OutfitsViewController{
                let indexPath = self.tableView?.indexPathForCell(sender as! AllShowsTableViewCell)
                let sectionId = indexPath!.section
                destinationVC.titleString = self.outfitArray[sectionId].outfitName
                destinationVC.descriptionString = self.outfitArray[sectionId].description
                destinationVC.outfitItemsList = self.outfitArray[sectionId].pieces!
                //destinationVC.imageForCharacter = self.imageCache[self.characterArray[sectionId].characterImage]
            }
        }

    }
}
