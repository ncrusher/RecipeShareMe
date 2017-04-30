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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
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


}
