//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by developer on 02/12/16.
//  Copyright (c) 2016 Wesley Egbertsen. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    var tweet: Tweet? {
        didSet {
            title = tweet!.user.screenName
            if !tweet!.media.isEmpty {
                menstionsSections.append(MentionsSections(header: "Images", mentions: tweet!.media.map { Mention.Image($0.url, $0.aspectRatio) }))
            }
            if !tweet!.hashtags.isEmpty {
                menstionsSections.append(MentionsSections(header: "Hashtags", mentions: tweet!.hashtags.map { Mention.Keyword($0.keyword) }))
            }
            if !tweet!.userMentions.isEmpty {
                menstionsSections.append(MentionsSections(header: "Users", mentions: tweet!.userMentions.map { Mention.Keyword($0.keyword) }))
            }
            if !tweet!.urls.isEmpty {
                menstionsSections.append(MentionsSections(header: "URLs", mentions: tweet!.urls.map { Mention.Keyword($0.keyword) }))
            }
        }
    }
    
    var menstionsSections = [MentionsSections]()
    
    struct MentionsSections {
        var header: String
        var mentions: [Mention]
    }
    
    enum Mention {
        case Keyword(String)
        case Image(NSURL, Double)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    private struct Storyboard {
        static let KeywordsCellReuseIdentifier = "Keywords Cell"
        static let ImagesCellReuseIdentifier = "Image Cell"
        static let KeywordsSegueIdentifier = "Show tweets from keyword"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menstionsSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menstionsSections[section].mentions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mention = menstionsSections[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.KeywordsCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = keyword
                return cell
        case .Image(let url, _):
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImagesCellReuseIdentifier, forIndexPath: indexPath) as! MentionsImageTableViewCell
                cell.imageUrl = url
                return cell
        }

        // Configure the cell...

        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menstionsSections[section].header
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = menstionsSections[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let uinc = destination as? UINavigationController {
            destination = uinc.visibleViewController
        }
        if let ttvc = destination as? TweetTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case Storyboard.KeywordsSegueIdentifier:
                    if let keywordCell = sender as? UITableViewCell {
                        ttvc.searchText = keywordCell.textLabel?.text
                    }
                default:
                    break
                }
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
