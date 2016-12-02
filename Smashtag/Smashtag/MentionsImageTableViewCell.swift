//
//  MentionsImageTableViewCell.swift
//  Smashtag
//
//  Created by developer on 02/12/16.
//  Copyright (c) 2016 Wesley Egbertsen. All rights reserved.
//

import UIKit

class MentionsImageTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var imageUrl: NSURL? { didSet { updateUI() } }

    func updateUI() {
        //reset any existing  information
        tweetImage.image = nil
        
        if let url = imageUrl {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                let tweetImageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if let image = tweetImageData {
                            self.tweetImage?.image = UIImage(data: image)
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
    
}
