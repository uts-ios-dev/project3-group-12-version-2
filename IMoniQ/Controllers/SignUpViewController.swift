//
//  SignUpViewController.swift
//  IMoniQ
//
//  Created by Jane on 21/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {

    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Registration successfull")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMenu", sender: self)
            }
        }
    }
}
