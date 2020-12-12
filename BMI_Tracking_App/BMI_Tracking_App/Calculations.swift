//
//  Calculations.swift
//  BMI_Tracking_App
//
//  Created by Abdeali Mody on 2020-12-11.
//  Student ID - 301085484
//  Version 1.0
//  Copyright © 2020 Abdeali. All rights reserved.
//  Description - This file is used to store the information

import Foundation
class Calculations
{
    var name :String = ""
    var age: String = ""
    var gender: String = ""
    var isMetric: Bool = true
    var weight:Double = 0.0
    var height:Double = 0.0
    var finalBMICalculation:Double = 0.0
    var dateIncluded: String = ""
    
    init( name: String, age: String, gender: String, isMetric: Bool, weight: Double, height: Double, finalBMICalculation:Double, dateIncluded: String)
    {
            self.name = name
            self.age = age
            self.gender = gender
            self.isMetric = isMetric
            self.weight = weight
            self.height = height
            self.finalBMICalculation = finalBMICalculation
            self.dateIncluded = dateIncluded
     }

    init()
    {

    
    }

}
