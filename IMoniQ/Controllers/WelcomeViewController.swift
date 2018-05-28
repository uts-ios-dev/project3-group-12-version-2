//
//  ViewController.swift
//  IMoniQ
//
//  Created by Jane on 13/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import ResearchKit
import UserNotificationsUI
import NotificationCenter
import UserNotifications

class WelcomeViewController: UIViewController, ORKTaskViewControllerDelegate {

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pushNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func pushNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
        var dateInfo = DateComponents()
        dateInfo.hour = 14
        dateInfo.minute = 45
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
}

