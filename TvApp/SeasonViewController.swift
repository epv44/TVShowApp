//
//  SeasonViewController.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import UIKit
import QuartzCore   

class SeasonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var titleString: String!
    var descriptionString: String!
    var episodeList: JSONArray = []
    var episodeArray : JSONEpisodeArray = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seasonImage: UIImageView!
    @IBOutlet weak var seasonDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColorFromHex(0xF2F2F2, alpha: 1)
        var titleLabel = UILabel(frame: CGRectMake(0 , 0, 200, 21))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvantGardeLT-Demi", size: 18)
        var nib = UINib(nibName: "seasonsTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        navigationItem.titleView = titleLabel
        seasonDescription.text=descriptionString
        for obj: AnyObject in episodeList{
            let episode = Episode.create1 <^>
                obj["title"]        >>> JSONString <*>
                obj["description"]  >>> JSONString
            
            episodeArray.append(episode!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.episodeArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("episodeCell", forIndexPath: indexPath) as UITableViewCell
//        cell.textLabel?.text = self.episodeArray[indexPath.section].name
        var cell:SeasonsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as SeasonsTableViewCell
        cell.seasonTitle.text = self.episodeArray[indexPath.section].name
        cell.seasonDescription.text = self.episodeArray[indexPath.section].description
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("characterSegue", sender: cell)
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
