//
//  LoginViewController.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/26/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit
import Parse
import Bolts
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHex("ecf0f1")
        
        usernameTextField.returnKeyType = .Next
        usernameTextField.delegate = self
        passwordTextField.secureTextEntry = true
        passwordTextField.returnKeyType = .Go
        passwordTextField.delegate = self
        
        styleLoginButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss keyboard when view is tapped
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    /**
    Validate empty text fields before proceeding to `loginWithUsername:password:`
    */
    @IBAction func validate() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if username.isEmpty || password.isEmpty {
            let alertController = UIAlertController(title: "Empty Field", message: "Please fill in username and password fields", preferredStyle: .Alert)
            
            let dismiss = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(dismiss)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            view.endEditing(true)
            loginWithUsername(username, password: password.md5())
        }
    }
    
    /**
    Login to the document uploader
    
    - parameter username: The username of the user
    - parameter password: The user's password in MD5 format
    */
    func loginWithUsername(username: String, password: String) {
        SVProgressHUD.showWithStatus("Logging In", maskType: .Black)
        
        PFUser.logInWithUsernameInBackground(username, password: password) {[unowned self] (user, error) -> Void in
            SVProgressHUD.dismiss()
            
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainController = storyboard.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = mainController
            }
            else {
                let errorDescription = error?.localizedDescription ?? "Failed to login."
                let alertController = UIAlertController(title: "Login Error", message: errorDescription, preferredStyle: .Alert)
                
                let dismiss = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(dismiss)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /**
    Style the login button
    */
    func styleLoginButton() {
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.backgroundColor = UIColor.colorWithHex("34495e")
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(18)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }

}
