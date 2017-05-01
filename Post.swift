//
//  Post.swift
//  RecipeShareMe
//
//  Created by Khai Le on 4/30/17.
//  Copyright © 2017 Kaiba. All rights reserved.
//

import Foundation

class Post {
    
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var caption: String {
        if _caption == nil {
            _caption = ""
            return _caption
        } else {
            
            return _caption
        }

    }
    
    var imageURL: String {
        
        return _imageURL
    }
    
    var likes: Int {
        
        return _likes
    }
    
    var postKey: String {
        
        return _postKey
    }
    
    init(caption: String, imageURL: String, likes: Int, postKey: String) {
        
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    
    //this init will convert the data from firebase into data we can use
    init(postKey: String, postData: Dictionary<String, Any>) {
        
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let likes = postData["likes"] as? Int {
            
            self._likes = likes
        }
        
    }
}
