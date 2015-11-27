//
//  AllShowsTableViewCell.swift
//  TvApp
//  Custom table view cell used for displaying all shows
//  Created by Eric Vennaro on 4/21/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit
import QuartzCore

class AllShowsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showCharacters: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        _ = cellView.layer
//        cellView.layer.shadowColor = UIColor.blackColor().CGColor
//        cellView.layer.shadowOffset = CGSize(width:0, height:2)
//        cellView.layer.shadowOpacity = 0.1
//        cellView.layer.shadowRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
