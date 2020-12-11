//
//  ViewController.swift
//  BMI_Tracking_App
//
//  Created by Abdeali Mody on 2020-12-10.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet var user_Name: UITextField!
    @IBOutlet var user_Age: UITextField!
    @IBOutlet var user_Gender: UITextField!
    @IBOutlet var user_calculationType: UISegmentedControl!
    @IBOutlet var user_Weight: UITextField!
    @IBOutlet var user_Height: UITextField!
    @IBOutlet var user_bmiResult: UITextView!
    var bmiCalculation:Calculations!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_Calculate(_ sender: UIButton)
    {
        bmiCalculation.name = user_Name.text!
        bmiCalculation.age = user_Age.text!
        bmiCalculation.gender = user_Gender.text!
        bmiCalculation.height = Double(user_Height.text!)!
        bmiCalculation.weight = Double(user_Weight.text!)!
        
        if(bmiCalculation.isMetric == true)
        {
            bmiCalculation.finalBMICalculation =  bmiCalculation.weight*703/bmiCalculation.height*bmiCalculation.height
        }
        else
        {
            bmiCalculation.finalBMICalculation =  bmiCalculation.weight/bmiCalculation.height*bmiCalculation.height
        }
        
        switch bmiCalculation.finalBMICalculation
        {
        case  0.0...16.0 :
            user_bmiResult.text = "Severe Thin"
        case  16.0..<17.0:
            user_bmiResult.text = "Moderate Thinness"
        case  17...18.5:
            user_bmiResult.text = "Mild Thinness"
        case  18.5...25:
            user_bmiResult.text = "Normal"
        case  25...30:
            user_bmiResult.text = "Overweight"
        case  30...35:
            user_bmiResult.text = "Obese Class I"
        case  35...40:
            user_bmiResult.text = "Obese Class II"
        case  40...:
            user_bmiResult.text = "Obese Class III"
        default:
            break
        }
    }
    
    @IBAction func calulationType(_ sender: UISegmentedControl)
    {
        print(user_calculationType.selectedSegmentIndex)
        
        switch user_calculationType.selectedSegmentIndex
        {
            case 0: bmiCalculation.isMetric = true
            case 1: bmiCalculation.isMetric = false
            default:
                break;
        }
    }
}

