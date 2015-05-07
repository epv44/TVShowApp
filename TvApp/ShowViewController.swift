//
//  ShowViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/28/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit
import QuartzCore

class ShowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showDescription: UITextView!
    var titleString: String!
    var descriptionString: String!
    var seasonList: JSONArray = []
    var seasonArray : JSONSeasonArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "seasonsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = GreenBackgroundFromHex()
        var titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        navigationItem.titleView = titleLabel
        showDescription.text=descriptionString
        for obj: AnyObject in seasonList {
            let season = Season.create <^>
                obj["title"]        >>> JSONString <*>
                obj["description"]  >>> JSONString <*>
                obj["episodes"]     >>> JSONObject
            seasonArray.append(season!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.title = titleString
        //        self.navigationController?.navigationBar.tintColor = GreenBackgroundFromHex()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return self.seasonArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("allEpisodes", forIndexPath: indexPath) as UITableViewCell
//        cell.textLabel?.text = self.seasonArray[indexPath.section].name
        var cell:SeasonsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as SeasonsTableViewCell
        cell.seasonTitle.text = self.seasonArray[indexPath.section].name
        cell.seasonDescription.text = self.seasonArray[indexPath.section].description
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("seasonSegue", sender: cell)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "seasonSegue"{
            if let navbar = segue.destinationViewController as? UINavigationController{
                if let destinationVC = navbar.topViewController as? SeasonViewController{
                    let indexPath = self.tableView?.indexPathForCell(sender as SeasonsTableViewCell)
                    let sectionId = indexPath!.section
                    destinationVC.titleString = self.seasonArray[sectionId].name
                    destinationVC.descriptionString = self.seasonArray[sectionId].description
                    destinationVC.episodeList = self.seasonArray[sectionId].episodes
                }
            }else{
                println("error")
            }
        }
    }
}
