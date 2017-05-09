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
    
    let likeRef = DataService.ds.REF_USER_CURRENT.child("likes")
    
    @IBOutlet weak var likeImg: CircleView!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        // this function should be put here in awakeFromNib
        let tap = UITapGestureRecognizer(target: self, action: #selector(likedTapped))
        
        tap.numberOfTapsRequired = 1 // requires only 1 tap to initialize
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
        
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
        
        // reference to the current user and the likes keys id

        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // if the value of the snapshot is null then we want to proform
            if let _ = snapshot.value as? NSNull {
                
                self.likeImg.image = UIImage(named: "empty-heart") // if the likes is null then set the image to an empty image
            }else {
                
                self.likeImg.image = UIImage(named: "filled-heart")
            }
            
        })
    }
    
    func likedTapped (sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // if the value of the snapshot is null then we want to proform
            if let _ = snapshot.value as? NSNull {
                
                self.likeImg.image = UIImage(named: "empty-heart") // if the likes is null then set the image to an empty image
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            }else {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
            
        })
        
    }



}
    

    




