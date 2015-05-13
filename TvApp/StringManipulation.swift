//
//  StringManipulation.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/11/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation
import Darwin

func stringLastIndexOf(src:String, target:UnicodeScalar) -> Int? {
    let c = Int32(bitPattern: target.value)
    return src.withCString { s -> Int? in
        let pos = strrchr(s, c)
        return pos != nil ? pos - s : nil
    }
}

func getImageNameFromUrl(urlString: String) -> String {
    return urlString.substringFromIndex(advance(urlString.startIndex, stringLastIndexOf(urlString, "/")!))
}