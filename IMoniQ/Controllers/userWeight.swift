//
//  UserPain.swift
//  IMoniQ
//
//  Created by Ding on 18/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//
import Foundation

struct userWeight: Codable {
    
    var weight: Float = 0
    var date: Date = Date()
    
    func getUserWeightHistory()
    {
        let defaults = UserDefaults.standard
        if let savedWeight = defaults.object(forKey: "weight") as? Data {
            let decoder = JSONDecoder()
            if let loadedWeight = try? decoder.decode(Array<userWeight>.self, from: savedWeight) {
                userWeightHistory = loadedWeight
            }
        }
    }
    
    func updateUserWeightHistory(currentWeight: Float)
    {
        let defaults = UserDefaults.standard
        let currentDate = Date()
        let weight = userWeight(weight: currentWeight, date: currentDate)
        getUserWeightHistory()
        userWeightHistory.append(weight)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userWeightHistory) {
            defaults.set(encoded, forKey: "weight")
        }
    }
    
    func deleteUserWeightHistory()
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "weight")
        userWeightHistory = Array()
    }
    
    
}

var userWeightHistory: Array<userWeight> = Array()
