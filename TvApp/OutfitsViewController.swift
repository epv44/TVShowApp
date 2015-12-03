//
//  OutfitsViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 6/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class OutfitsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var items: [(String, String)] = [
        ("Louis Vitton Suit Jacket", "swift 1.jpeg"),
        ("Bonobos Chino's", "swift 2.jpeg"),
        ("All Silk Bonobos Tie", "swift 3.jpeg"),
        ("Gucci 500 Series Watch", "swift 4.jpeg"),
        ("Johnston Murphy Leather Chukas", "swift 5.jpeg")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    var titleString: String!
    
    var descriptionString: String!
    var outfitItemsList: JSONArray = []
    var outfitItemsArray : JSONOutfitItemArray = []
    var imageOfOutfit: UIImage!
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove blue line from under navbar
        self.navigationController?.navigationBar.clipsToBounds = true
        
        //gesture for transition
//        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showSecondViewController")
//        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
//        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        //table cell nib
        let nib = UINib(nibName: "outfitTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        let titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)

        navigationItem.titleView = titleLabel
        
//        for obj: AnyObject in outfitItemsList {
//            let piece = OutfitItem.create <^>
//                obj["name"]             >>> JSONString <*>
//                obj["description"]      >>> JSONString <*>
//                obj["price"]            >>> JSONString <*>
//                obj["purchase_url"]     >>> JSONString
//            outfitItemsArray.append(piece!)
//        }
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
        return self.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.height;
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //set up the cell
        let cell:OutfitTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! OutfitTableViewCell
        let (title, image) = items[indexPath.row]
        cell.loadItem(title: title, fullscreenImage: image, outfitImage: imageOfOutfit)
        
        //reset object if it hasn't been dequed
        if(!cell.isDequed){
            cell.resetFavoritesAnimations()
            cell.resetPurchaseAnimations()
            cell.resetCollectionLabelAnimations()
            cell.resetPriceLabelAnimations()
            cell.resetTitleLabelAnimations()
        }
        //set dequed flag
        cell.isDequed = false
        //complete animations...title label, collection label, and price label fly up
        //favorite button and purchase button fly right
        //images fade in
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            cell.itemImage.alpha = 0.0
            cell.animateTitle()
            cell.animateCollection()
            cell.animatePrice()
            cell.itemImage.alpha = 1.0
            
        }, completion: nil)
        //animate favorite button
        UIView.animateWithDuration(1.15, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            cell.animateFavorite()
        }, completion: nil)

        //animate purchase button
        UIView.animateWithDuration(1.15, delay: 0.75, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            cell.animatePurchase()
        }, completion: nil)
        UIView.commitAnimations()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
            //segue to nothing? the buttons inside would go to links of the item or to
        //favorite the item
    }
    
    
    // MARK: - Navigation
//
//    func showSecondViewController() {
//        self.performSegueWithIdentifier("idFirstSegue", sender: self)
//    }
//    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//        if let id = identifier{
//            if id == "idFirstSegueUnwind" {
//                let unwindSegue = FirstCustomSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
//                    
//                })
//                return unwindSegue
//            }
//        }
//        
//        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
//    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "idFirstSegue"{
//            if let destinationViewController = segue.destinationViewController as? ImageViewController{
//                destinationViewController.titleString = "We"
//                destinationViewController.img = "swift 2.jpeg"
//            }
//        }
//    }
}
