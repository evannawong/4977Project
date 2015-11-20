//
//  AnnouncementTableViewController.swift
//  TermProject
//
//  Created by Victor on 2015-11-19.
//  Copyright © 2015 Evanna Wong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AnnouncementTableViewController: UITableViewController{
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var announcementTable: UITableView!
    var announcements = [Announcement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData(){
        let path = "https://api.mongolab.com/api/1/databases/comp4977project/collections/Announcement?apiKey=QNwCXLgMzmjtezI0ZIubDsy0QZkKdWAX"
        
        Alamofire.request(.GET, path)
            .responseJSON { response in
            switch response.result {
            case .Success:
            if let value = response.result.value {
                let json = JSON(value)
                    if let jsonArray = json.array {
                        for announcement in jsonArray {
                            let oneAnnouncement = Announcement (
                                date:announcement["Date"].stringValue,
                                time:announcement["Time"].stringValue,
                                category:announcement["Category"].stringValue,
                                message:announcement["Message"].stringValue,
                                detail:announcement["Details"].stringValue,
                                contact:announcement["Contact"].stringValue,
                                location:announcement["Location"].stringValue
                            )
                            
                            self.announcements.append(oneAnnouncement)
                            print(self.announcements)
                            self.tableView.reloadData()
                        }
                    }
                }
            case .Failure(let error):
                print(error)
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcements.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AnnouncementCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AnnouncementTableViewCell

        let announcement = self.announcements[indexPath.row]
        
        switch announcement.Category {
        case "Campus":
            cell.backgroundColor = UIColor(red: 203/255, green: 234/255, blue: 239/255, alpha: 0.4)
        case "Course":
            cell.backgroundColor = UIColor(red: 253/255, green: 214/255, blue: 214/255, alpha: 0.4)
        default:
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        cell.dateLabel.text = announcement.Date
        cell.messageLabel.text = announcement.Message
        cell.locationLabel.text = announcement.Location
        cell.timeLabel.text = announcement.Time
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }

}
