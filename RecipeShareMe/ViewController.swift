//
//  ViewController.swift
//  RecipeShareMe
//
//  Created by Khai Le on 4/23/17.
//  Copyright © 2017 Kaiba. All rights reserved.
//

import UIKit
import Foundation
import FBSDKLoginKit

import Firebase
import FacebookLogin


class ViewController: UIViewController, FBSDKLoginButtonDelegate{

    @IBOutlet weak var FBButton: FBSDKLoginButton!

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
    
        
    FBButton.delegate = self
    FBButton.readPermissions = ["email"]
    
        
        
    super.viewDidLoad()
        
        
        

    }

    
    
    
    @IBAction func signinPressed(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil { //if no errors then we are sign in
                    print("JESS: Email user authenticated with Firebase")
                    
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS: Unable to authenticate with Firebase using email")
                            
                        } else {
                            print("JESS: Successfully authenticated with Firebase")
                            
                        }
                    })
                }
            })
        }
    }
    
    
    func loginButtonDidLogOut(_ FFButton: FBSDKLoginButton!) {
        
        print("Did Logout out of facebook")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
            
        }
        
        showEmailAddress()

        }
    
    
    func showEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current() // gets the accesstoken for you
        guard let accessTokenString = accessToken?.tokenString else //guards against errors when getting the access token string
        { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            
            if error != nil {

                print("Something went wrong with our FB user: ", error!)
                return
            }
            
            print("Successfully logged in with our user: ", user!)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err!)
                return
            }
            
            print(result!)
            
            
    }
}
    


}

