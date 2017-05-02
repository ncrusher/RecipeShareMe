//
//  PostCell.swift
//  RecipeShareMe
//
//  Created by Khai Le on 4/28/17.
//  Copyright © 2017 Kaiba. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl:UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil) { // sets it with the optional and = nil will give it the default value of nil
        
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        //gets the image url
        // if an image is store in img then postImg.image is set = img
        if img != nil {
            self.postImg.image = img
        } else {
            
            // we will go to storage and download the picture from the web or firebase storage
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
        
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data,error) in // calculation for the max storage size of the image
            
                    if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                    } else {
                        print("JESS: Image downloaded from Firebase storage")
                        if let imgData = data { //sets img Data to the data that was downloaded
                            if let img = UIImage(data: imgData) { // sets img to imgdata if it is an image
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                            }
                        }
                    
            }
                })
        
            }
        }

        
    }
    

    




