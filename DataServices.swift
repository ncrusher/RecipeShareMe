//
//  DataServices.swift
//  RecipeShareMe
//
//  Created by Khai Le on 4/29/17.
//  Copyright © 2017 Kaiba. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference() //this gets the URL that is stored in googleservice-info plist
let STORAGE_BASE = FIRStorage.storage().reference() //this get the the URL in the storage firebase

class DataService {
    
    static let ds = DataService() //creates a singleton, single instance of this class and lets it use in any controller in your app
    
    
    //Database references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts") //child appends posts to the end of the URL, gets all the child of DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference {
        
        return _REF_POSTS
    }
    
    var REF_POSTS: FIRDatabaseReference {
        
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFireBaseUser(uid: String, userData: Dictionary<String, String>) {
        
        //updating the child values with userData for the uid for this user
        //does not overwrite data, can add new data if it is not there
        REF_USERS.child(uid).updateChildValues(userData) //Firebase will create a user if it does not exist
    }
    
    func createFireBasePost(uid: String, postData: Dictionary<String, String>) {
        
        
    }
    
    
}
