//
//  OutfitTableViewCell.swift
//  TvApp
//
//  Created by Eric Vennaro on 11/25/15.
//  Copyright © 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class OutfitTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
