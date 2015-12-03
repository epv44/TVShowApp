//
//  CharacterOverviewTableViewCell.swift
//  TvApp
//
//  Created by Eric Vennaro on 12/3/15.
//  Copyright © 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class CharacterOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var outfitImage: UIImageView!
    @IBOutlet weak var outfitTitle: UILabel!
    @IBOutlet weak var outfitPhrase: UILabel!
    @IBOutlet weak var numberOfFavorites: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //right now numberOfFavorites is constant
    //initially image is set to nil
    func loadItem(title title: String, phrase: String, numFavorites: String){
        outfitTitle.text = title
        outfitPhrase.text = phrase
        numberOfFavorites.text = numFavorites
        outfitImage.image = nil
    }
    @IBAction func favoriteOutfit(sender: AnyObject) {
        print("Favoriting the outfit")
    }

}
