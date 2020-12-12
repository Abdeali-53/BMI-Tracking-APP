//
//  ViewController.swift
//  BMI_Tracking_App
//
//  Created by Abdeali Mody on 2020-12-10.
//  Student ID - 301085484
//
//  Description - Built a BMI Calculator, First screen is used to take the user input & Calculate the BMI of that person.
//  2nd Screen lets the user to view when did they calculated their BMI with date and time, They can even update the Weight and calculate the BMI Again.
//  Version 1.0
//  Copyright © 2020 Abdeali. All rights reserved.

import UIKit

class ViewController: UIViewController
{
        // Declaring the User Interface Variables.
       @IBOutlet var user_Name: UITextField!
       @IBOutlet var user_Age: UITextField!
       @IBOutlet var user_Gender: UITextField!
       @IBOutlet var user_calculationType: UISegmentedControl!
       @IBOutlet var user_bmiResult: UITextView!
       @IBOutlet var user_Weight: UITextField!
       @IBOutlet var user_Height: UITextField!
       
       var isMetric = true
     
       var database: Database = Database()
    
       //Defining the calculation type (Metric or Imperial)
       @IBAction func calculationType(_ sender: UISegmentedControl)
       {
          print(user_calculationType.selectedSegmentIndex)
                  
          switch user_calculationType.selectedSegmentIndex
          {
            case 0: isMetric = true
            case 1: isMetric = false
            default:
            break;
          }
       }
    //This will help user to clear all the input fields.
    @IBAction func btn_reset(_ sender: UIButton)
    {
        user_Name.text = ""
        user_Age.text =  ""
        user_Gender.text = ""
        user_Weight.text = ""
        user_Height.text = ""
        user_bmiResult.text = ""
    }
       //This fuction helps to do the calculation part of the BMI App
       @IBAction func btn_Calculate(_ sender: UIButton)
       {
           var finalBMICalculation = 0.0
           let name = user_Name.text!
           let age = user_Age.text!
           let gender = user_Gender.text!
           let height = Double(user_Height.text!)!
           let weight = Double(user_Weight.text!)!
        
           if(isMetric == true)
           {
                //Formula for Metric Calculation.
                finalBMICalculation = weight/(height*height)
           }
           else
           {
                //Formula for Imperial Calculation.
                finalBMICalculation =  (weight*703)/(height*height)
              
           }
           
           // get the current date and time
           let currentDateTime = Date()

           // initialize the date formatter and set the style
           let formatter = DateFormatter()
           formatter.timeStyle = .short
           formatter.dateStyle = .short
           let data = formatter.string(from: currentDateTime)
           
           database.insert(user_Name: name, user_Age: age, user_Gender: gender, user_calculationType: (isMetric == true ? 0 : 1), user_Weight: weight, user_Height: height, user_bmiResult: finalBMICalculation, date_Included: data)
           
           var bmiResult = "Result: \n"
           
           let formatterValue = NumberFormatter()
           formatterValue.numberStyle = .decimal
           formatterValue.maximumFractionDigits = 2
           let formattedAmount = formatterValue.string(from: finalBMICalculation as NSNumber)!
           
           bmiResult += String(formattedAmount)
           bmiResult += "\n\nCategory: \n"
           
           //This swtich case is used to define the category of BMI result.
           switch finalBMICalculation
           {
           case  0.0...16.0 :
               bmiResult += "Severe Thin"
           case  16.0..<17.0:
               bmiResult +=  "Moderate Thinness"
           case  17...18.5:
               bmiResult += "Mild Thinness"
           case  18.5...25:
               bmiResult += "Normal"
           case  25...30:
               bmiResult += "Overweight"
           case  30...35:
               bmiResult += "Obese Class I"
           case  35...40:
               bmiResult += "Obese Class II"
           case  40...:
               bmiResult +=  "Obese Class III"
           default:
               break
           }
           //Displaying the result.
           user_bmiResult.text = bmiResult
       }
    
    override func viewDidLoad()
    {
           super.viewDidLoad()
       }
}

