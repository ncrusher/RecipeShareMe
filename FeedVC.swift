//
//  FeedVC.swift
//  RecipeShareMe
//
//  Created by Khai Le on 4/26/17.
//  Copyright © 2017 Kaiba. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper



class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var captionLbl: UITextField!
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false // guards against the original image from being uploaded
    
    @IBOutlet weak var addImage: UIImageView!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache() // makes an image cache

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        //to implete a immage picker import imagepicerdelegate & UINavigationcontrollerdelgate
        //func imagepiker didfinishpicking
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //implement a listner whenever something updates in the post it will listen for updates and post the updates to firbase
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict as Dictionary<String, AnyObject>)
                        self.posts.append(post)
                    }
    
                }
            }
            self.tableView.reloadData()

            
        })
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("JESS: A valid image wasn't selected")
        
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func addImagePressed(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
            }
            cell.configureCell(post: post, img: nil)
            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        //removes your KEY ID from the keychain so you are not logged in
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID REMOVED FROM KEYCHAIN \(keychainResult)")
        
        //signs you out of firebase
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
        
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
        guard let caption = captionLbl.text, caption != "" else {
            print("JESS: Caption must be entered")
            return
        }
        
        guard let img = addImage.image, imageSelected == true else {
            print("JESS: Image needs to be added")
            return
        }
        
        // converts our image into imgdata to prepare to be uploaded to firebase
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            // this creates a unique identifier for the img so we can reference it later
            let imgUid = NSUUID().uuidString
            
            // makes a constant and sets it to firebase meta data, meta data decribes what type of data the data is
            let metadata = FIRStorageMetadata()
            
            // sets the meta data content to image of type JPEG
            metadata.contentType = "image/JPEG"
            
            // we are passing up the information for this img with the corressponding imgUid
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    
                    print("JESS: Unable to upload image to firebase storage.")
                } else {
                    print("JESS: Successfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imgUrl: downloadURL)
                    
                }
                
                }
        }
        
    }
    
    func postToFirebase (imgUrl: String!) {
        
        let post: Dictionary<String, Any> = [
        "caption": captionLbl.text,
        "imageURL": imgUrl,
        "likes": 0
        ]
        
        // child by auto id alllows you to create a randomly generated ID
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        
        // this sets the value to our new post with the data from post. creates a new user and new post
        firebasePost.setValue(post)
        
        // after you ost want to set everything back to default values
        captionLbl.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }

}
