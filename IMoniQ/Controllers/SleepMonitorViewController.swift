//
//  SleepMonitorViewController.swift
//  IMoniQ
//
//  Created by Jane on 14/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import HealthKit

class SleepMonitorViewController: UIViewController {

    var startTime = TimeInterval()
    var timer:Timer = Timer()
    var endTime: NSDate!
    var alarmTime: NSDate!
    
    let healthStore = HKHealthStore()
    
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startSleep(_ sender: UIButton) {
        alarmTime = NSDate()
    }
    @IBAction func stopSleep(_ sender: Any) {
        endTime = NSDate()
        saveSleepAnalysis()
        retrieveSleepAnalysis()
    }
    @objc func updateTime() {
    }
    
    func saveSleepAnalysis() {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let object = HKCategorySample(type:sleepType, value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: self.alarmTime as Date as Date, end: self.endTime as Date)
            healthStore.save(object, withCompletion: { (success, error) -> Void in
                if error != nil {
                    return
                }
                if success {
                    print("My new data was saved in HealthKit")
                } else {
                }
                
            })
            let object2 = HKCategorySample(type:sleepType, value: HKCategoryValueSleepAnalysis.asleep.rawValue, start: self.alarmTime as Date, end: self.endTime as Date)
            
            healthStore.save(object2, withCompletion: { (success, error) -> Void in
                if error != nil {
                    return
                }
                
                if success {
                    print("My new data (2) was saved in HealthKit")
                } else {
                }
                
            })
            
        }
        
    }
    
    func retrieveSleepAnalysis() {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    return
                }
                
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                        }
                    }
                }
            }
            healthStore.execute(query)
        }
    }
}
