//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by developer on 30/11/16.
//  Copyright (c) 2016 Wesley Egbertsen. All rights reserved.
//

import UIKit

private extension NSMutableAttributedString {
    // returns self to enable method chaining
    func addTweetColors(indexedKeyWords: [Tweet.IndexedKeyword], color: UIColor) -> NSMutableAttributedString {
        for keyword in indexedKeyWords {
            self.addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
        return self
    }
}

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    var hashtagColor = UIColor.blueColor() {
        didSet {
            updateUI()
        }
    }
    var urlColor = UIColor.brownColor(){
        didSet {
            updateUI()
        }
    }
    var userColor = UIColor.grayColor(){
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        //reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil

        if let tweet = self.tweet {
            var text = tweet.text
            for _ in tweet.media {
                text += " 📷"
            }
            tweetTextLabel.attributedText = NSMutableAttributedString(string: text)
                .addTweetColors(tweet.hashtags, color: hashtagColor)
                .addTweetColors(tweet.urls, color: urlColor)
                .addTweetColors(tweet.userMentions, color: userColor)
            
            tweetScreenNameLabel?.text = "\(tweet.user)" //tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                var qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    let data = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        // check if the image is still okay for the current cell, because threads can cause concurrency problems
                        if profileImageURL == tweet.user.profileImageURL && data != nil {
                            self.tweetProfileImageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
    
    
}
