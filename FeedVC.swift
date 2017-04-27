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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func signOutPressed(_ sender: Any) {
        
        //removes your KEY ID from the keychain so you are not logged in
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID REMOVED FROM KEYCHAIN \(keychainResult)")
        
        //signs you out of firebase
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
        
    }


}
