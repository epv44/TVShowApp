//
//  ColorFromHex.swift
//  TvApp
//  Allows for the use of hex colors, which I have no idea why this is not natively supported by UIColor
//  Created by Eric Vennaro on 4/21/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation
import UIKit

func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)-> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}