//
//  CurrentEpisodeViewCell.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/27/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit
import QuartzCore

class CurrentEpisodeViewCell: UITableViewCell {

    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeDescription: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        var layer = cellView.layer
        cellView.layer.shadowColor = UIColor.blackColor().CGColor
        cellView.layer.shadowOffset = CGSize(width:0, height:2)
        cellView.layer.shadowOpacity = 0.1
        cellView.layer.shadowRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
