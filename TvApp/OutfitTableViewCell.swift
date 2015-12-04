//
//  OutfitTableViewCell.swift
//  TvApp
//
//  Created by Eric Vennaro on 11/25/15.
//  Copyright © 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class OutfitTableViewCell: UITableViewCell {

    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    var isDequed: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.backgroundColor = GreenBackgroundFromHex()
        favoriteButton.layer.cornerRadius = 4
        favoriteButton.layer.borderWidth = 1
        favoriteButton.layer.borderColor = GreenBackgroundFromHex().CGColor
        purchaseButton.backgroundColor = GreenBackgroundFromHex()
        purchaseButton.layer.cornerRadius = 4
        purchaseButton.layer.borderWidth = 1
        purchaseButton.layer.borderColor = GreenBackgroundFromHex().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadItem(title title: String, backgroundImageURL: String, outfitImage: UIImage, retailer: String, price:String, subheader: String) {
        backgroundImage.image = nil
        let urlString = backgroundImageURL
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket = S3BucketName
        getPreSignedURLRequest.key = urlString
        getPreSignedURLRequest.HTTPMethod = AWSHTTPMethod.GET
        getPreSignedURLRequest.expires = NSDate(timeIntervalSinceNow: 3600)
        
        //check if URL is in array, if not then perform async request to get the urls set url string outside of this block
        if let img = GlobalVariables.imageCache[urlString]{
            backgroundImage.image = img
        }else{
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
                                let img = UIImage(data: data!)
                                let image = self.applyFilter(img!)
                                // Store the image in to our cache, if the image is missing ignore for now
                                if urlString.rangeOfString("missing.png") == nil {
                                    GlobalVariables.imageCache[urlString] = image
                                }
                                // Update the cell
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.backgroundImage.image = image
                                    self.reloadInputViews()
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
        titleLabel.text = title
        itemImage.image = outfitImage
        priceLabel.text = "On " + retailer + " for $" + price
        collectionLabel.text = subheader
    }
    
    func applyFilter(fullscreenImage: UIImage) -> UIImage{
        let imageToBlur: CIImage = CIImage(image: fullscreenImage)!
        let clampFilter: CIFilter = CIFilter(name:"CIColorClamp")!
        clampFilter.setValue(imageToBlur, forKey:kCIInputImageKey)
        clampFilter.setValue(CIVector(x: 0.8, y: 0.8, z: 0.8, w: 0.8), forKey: "inputMaxComponents")
        clampFilter.setValue(CIVector(x: 0.15, y: 0, z: 0.15, w: 0), forKey: "inputMinComponents")
        let filteredIm: CIImage = clampFilter.outputImage!
        let filteredImage = UIImage(CIImage: filteredIm)
        
        return filteredImage
    }
    
    // MARK: - Animations
    func animateTitle(){
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                      titleLabel.frame.origin.y - 200,
                                      titleLabel.frame.size.width,
                                      titleLabel.frame.size.height)
    }
    
    func animateCollection(){
        collectionLabel.frame = CGRectMake(collectionLabel.frame.origin.x,
                                           collectionLabel.frame.origin.y - 200,
                                           collectionLabel.frame.size.width,
                                           collectionLabel.frame.size.height)
    }
    
    func animatePrice(){
        priceLabel.frame = CGRectMake(priceLabel.frame.origin.x,
                                      priceLabel.frame.origin.y - 200,
                                      priceLabel.frame.size.width,
                                      priceLabel.frame.size.height)
    }
    
    func animateFavorite(){
        favoriteButton.alpha = 0
        favoriteButton.frame = CGRectMake(favoriteButton.frame.origin.x + 250,
                                          favoriteButton.frame.origin.y,
                                          favoriteButton.frame.size.width,
                                          favoriteButton.frame.size.height)
        favoriteButton.alpha = 1
    }
    
    func animatePurchase(){
        purchaseButton.alpha = 0.0
        purchaseButton.frame = CGRectMake(purchaseButton.frame.origin.x + 250,
                                          purchaseButton.frame.origin.y,
                                          purchaseButton.frame.size.width,
                                          purchaseButton.frame.size.height)
        purchaseButton.alpha = 1.0
    }
    
    func resetFavoritesAnimations(){
        favoriteButton.frame = CGRectMake(favoriteButton.frame.origin.x - 250,
                                          favoriteButton.frame.origin.y,
                                          favoriteButton.frame.size.width,
                                          favoriteButton.frame.size.height)
    }
    
    func resetPurchaseAnimations(){
        purchaseButton.frame = CGRectMake(purchaseButton.frame.origin.x - 250,
                                          purchaseButton.frame.origin.y,
                                          purchaseButton.frame.size.width,
                                          purchaseButton.frame.size.height)
    }
    
    func resetTitleLabelAnimations(){
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                      titleLabel.frame.origin.y + 200,
                                      titleLabel.frame.size.width,
                                      titleLabel.frame.size.height)
    }
    
    func resetCollectionLabelAnimations(){
        collectionLabel.frame = CGRectMake(collectionLabel.frame.origin.x,
                                           collectionLabel.frame.origin.y + 200,
                                           collectionLabel.frame.size.width,
                                           collectionLabel.frame.size.height)
    }
    
    func resetPriceLabelAnimations(){
        priceLabel.frame = CGRectMake(priceLabel.frame.origin.x,
                                      priceLabel.frame.origin.y + 200,
                                      priceLabel.frame.size.width,
                                      priceLabel.frame.size.height)
    }
    
    //MARK: - Button Actions
    
    @IBAction func clickPurchase(sender: AnyObject) {
        print("making purchase...")
    }
    @IBAction func clickFavorite(sender: AnyObject) {
        print("favoriting item")
    }

}
