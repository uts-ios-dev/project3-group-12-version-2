//
//  MenuViewController.swift
//  IMoniQ
//
//  Created by Jane on 14/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: BasicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SignOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("error, there is a problem signout")
            self.prompt("error, there is a problem signout")
        }
    }
}
