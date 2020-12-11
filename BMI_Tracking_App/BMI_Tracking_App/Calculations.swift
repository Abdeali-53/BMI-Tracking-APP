//
//  Calculations.swift
//  BMI_Tracking_App
//
//  Created by Abdeali Mody on 2020-12-11.
//

import Foundation
class Calculations: NSObject
{
    var name :String
    var age: String
    var gender: String
    var isMetric: Bool
    var weight:Double
    var height:Double
    var finalBMICalculation:Double
    
    init( name: String, age: String, gender: String, isMetric: Bool, weight: Double, height: Double, finalBMICalculation:Double)
    {
            self.name = name
            self.age = age
            self.gender = gender
            self.isMetric = isMetric
            self.weight = weight
            self.height = height
        self.finalBMICalculation = finalBMICalculation
     }

    init(key: String, todo: NSDictionary)
    {
       
        self.name = todo["name"] as! String
        self.age = todo["age"] as! String
        self.gender = todo["gender"] as! String
        self.isMetric = todo["isMetric"] as! Bool
        self.weight = todo["weight"] as! Double
        self.height = todo["height"] as! Double
        self.finalBMICalculation  = todo["finalBMICalculation"] as! Double
    }

    convenience override init()
    {
        self.init(name: "", age: "", gender: "" , isMetric: true, weight: 0.0, height: 0.0, finalBMICalculation:0.0)
    }
}
