//
//  SettingsViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/13/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        //remove blue line from under navbar
        self.navigationController?.navigationBar.clipsToBounds = true
        
        let titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 30))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "Settings"
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        navigationItem.titleView = titleLabel
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
