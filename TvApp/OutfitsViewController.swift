//
//  OutfitsViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 6/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class OutfitsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var titleString: String!
    var descriptionString: String!
    var outfitItemsList: JSONArray = []
    var outfitItemsArray : JSONOutfitItemArray = []
    var imageForOutfit: UIImage!
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var outfitImage: UIImageView!
    @IBOutlet weak var outfitDescription: UITextView!
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
        //outfit pieces list
        self.outfitDescription.scrollRangeToVisible(NSMakeRange(0,0))
        self.outfitImage.image = imageForOutfit
        for obj: AnyObject in outfitItemsList {
            let piece = OutfitItem.create <^>
                obj["name"]             >>> JSONString <*>
                obj["description"]      >>> JSONString <*>
                obj["price"]            >>> JSONString <*>
                obj["purchase_url"]     >>> JSONString
            outfitItemsArray.append(piece!)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.outfitItemsArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    //switch to outfit
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:AllShowsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! AllShowsTableViewCell
        cell.showTitle.text = self.outfitItemsArray[indexPath.section].name
        cell.showImage.image = nil
        
//        var urlString = self.outfitItemsArray[indexPath.section].outfitImage
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
//                                    self.imageCache[urlString] = self.characterImage.image
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
        performSegueWithIdentifier("outfitSegue", sender: cell)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
