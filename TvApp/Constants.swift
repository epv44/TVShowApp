//
//  constants.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/9/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

let CognitoRegionType = AWSRegionType.USEast1
let DefaultServiceRegionType = AWSRegionType.USEast1
let CognitoIdentityPoolId: String = "us-east-1:02443252-789b-4643-b163-276824d47242"
let S3BucketName: String = "threads-development"
let S3DownloadKeyName: String = "shows/images/000/000/021/original/Eric_Signature.png"

//let S3UploadKeyName: String = "uploadfileswift.txt"
let BackgroundSessionUploadIdentifier: String = "com.amazon.example.s3BackgroundTransferSwift.uploadSession"
let BackgroundSessionDownloadIdentifier: String = "com.amazon.example.s3BackgroundTransferSwift.downloadSession"