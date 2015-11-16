//
//  AppDelegate.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/13/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundDownloadSessionCompletionHandler: ()?
    var backgroundUploadSessionCompletionHandler: ()?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //sets the status bar (very top bar with battery icon) color
        let appWidth = self.window?.bounds.width
        let statusBar = UIView()
        statusBar.frame = CGRectMake(0,0,appWidth!,20)
        statusBar.backgroundColor = GreenBackgroundFromHex()
        self.window?.rootViewController?.view.addSubview(statusBar)
        //UINavigationBar.appearance().backgroundColor = GreenBackgroundFromHex()
        let credentialProvider = AWSCognitoCredentialsProvider(
            regionType: CognitoRegionType,
            identityPoolId: CognitoIdentityPoolId)
        let configuration = AWSServiceConfiguration(
            region: DefaultServiceRegionType,
            credentialsProvider: credentialProvider)
        AWSLogger.defaultLogger().logLevel = .Verbose
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

        return true
    }
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        
       // NSLog("[%@ %@]", reflect(self).summary, __FUNCTION__)
        /*
        Store the completion handler.
        */
        if identifier == BackgroundSessionUploadIdentifier {
            self.backgroundUploadSessionCompletionHandler = completionHandler()
        } else if identifier == BackgroundSessionDownloadIdentifier {
            self.backgroundDownloadSessionCompletionHandler = completionHandler()
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

