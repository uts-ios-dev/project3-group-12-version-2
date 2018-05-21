//
//  SignInViewController.swift
//  IMoniQ
//
//  Created by Jane on 21/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func SignInPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
        { (user, error) in
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
