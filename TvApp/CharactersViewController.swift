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
        let nib = UINib(nibName: "characterOutfitsTableCell", bundle: nil)
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.outfitArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.height;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for cell in tableView.visibleCells as [UITableViewCell] {
            let point = tableView.convertPoint(cell.frame.origin, toView: tableView.superview)
            let pointScale = point.y / CGFloat(tableView.superview!.bounds.size.height)
            cell.contentView.alpha = 1-(pointScale - 0.12)
        }
    }

    //switch to outfit
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CharacterOverviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! CharacterOverviewTableViewCell
        cell.loadItem(title: self.outfitArray[indexPath.row].outfitName!, phrase: self.outfitArray[indexPath.row].description!, numFavorites: "53")
        
        let urlString = self.outfitArray[indexPath.row].outfitImageURL!
        if let img = GlobalVariables.imageCache[urlString]{
            cell.outfitImage.image = img
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
                                    GlobalVariables.imageCache[urlString] = self.characterImage.image
                                }else{
                                    GlobalVariables.imageCache[urlString] = image
                                }
                                // Update the cell
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? CharacterOverviewTableViewCell{
                                        cellToUpdate.outfitImage.image = image
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
                let indexPath = self.tableView?.indexPathForCell(sender as! CharacterOverviewTableViewCell)
                let rowId = indexPath!.row
                destinationVC.titleString = self.outfitArray[rowId].outfitName
                destinationVC.descriptionString = self.outfitArray[rowId].description
                destinationVC.outfitItemsList = self.outfitArray[rowId].pieces!
                //image for character will go to the small image...
                destinationVC.imageOfOutfit = GlobalVariables.imageCache[self.outfitArray[rowId].outfitImageURL!]
            }
        }

    }
}
