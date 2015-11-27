//
//  OutfitsViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 6/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class OutfitsViewController: UIViewController {

    var items: [(String, String)] = [
        ("❤", "swift 1.jpeg"),
        ("We", "swift 2.jpeg"),
        ("❤", "swift 3.jpeg"),
        ("Swift", "swift 4.jpeg"),
        ("❤", "swift 5.jpeg")
    ]
    
    var titleString: String!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var descriptionString: String!
    var outfitItemsList: JSONArray = []
    var outfitItemsArray : JSONOutfitItemArray = []
    var imageForOutfit: UIImage!
    private var imageCache: Dictionary<String, UIImage> = [String: UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        let(title, image) = items[0]
        backgroundImage.image = UIImage(named: image)
        nameLabel.text = title
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
