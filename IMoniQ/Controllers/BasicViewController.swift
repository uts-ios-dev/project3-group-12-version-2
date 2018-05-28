//
//  BasicViewController.swift
//  IMoniQ
//
//  Created by Zhaoqing Liu on 27/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    
    /// Pop-up prompt window
    func prompt(_ message: String) {
        
        let sheet = UIAlertController.init(title: "Prompt Message", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        sheet.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
            
        }))
        self.present(sheet, animated: true, completion: nil)
    }

}
