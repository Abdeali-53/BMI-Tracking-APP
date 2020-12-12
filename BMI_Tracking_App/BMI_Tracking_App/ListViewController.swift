//
//  ListViewController.swift
//  BMI_Tracking_App
//
//  Created by Abdeali Mody on 2020-12-11.
//  Student ID - 301085484
//  Version 1.0
//  Copyright © 2020 Abdeali. All rights reserved.

import UIKit

class ListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet var newWeight: UITextField!
    var database: Database = Database()
    var calcBmi:[Calculations] = []

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        calcBmi = database.query()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        calcBmi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var text = "Name: " + calcBmi[indexPath.row].name
        text += "  Result: " + String(format: "%.2f", calcBmi[indexPath.row].finalBMICalculation)
        text += "  Weight: " + String(calcBmi[indexPath.row].weight) + (calcBmi[indexPath.row].isMetric ? "(Kg)" : "(Pounds)")
     
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = calcBmi[indexPath.row].dateIncluded
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)

          return cell
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {

        let updateAction = UIContextualAction(style: .normal, title: "Update") {  (contextualAction, view, boolValue) in
            
        if (self.newWeight.text == "")
        {
        
        //alert when the input is empty
        let alert = UIAlertController(title: "Update Action", message: "Please provide your new weight", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
        //calling the screen again
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "listViewController") as? ListViewController
        else
        {
            return
        }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
        }))
            self.present(alert, animated: true, completion: nil)
    }
        else
        {
                var title = ""
                if(self.calcBmi[indexPath.row].isMetric)
                {
                    title = "Did you provide the weight in Kg ?"
                }
                else
                {
                    title = "Did you provide the weight in Pounds ?"
                }
                //alert asking if the user typed the correct unit (metric or imperial)
                let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in

                    var finalBMICalculation = 0.0
                    //checking if it is metric or imperial
                    if(self.calcBmi[indexPath.row].isMetric)
                       {
                        finalBMICalculation =  Double(self.newWeight.text!)! / (self.calcBmi[indexPath.row].height * self.calcBmi[indexPath.row].height)
                       }
                       else
                       {
                           finalBMICalculation =  (Double(self.newWeight.text!)! * 703 ) / (self.calcBmi[indexPath.row].height * self.calcBmi[indexPath.row].height)
                       }
                      //update
                      self.database.update(user_Name: self.calcBmi[indexPath.row].name, date_Included: self.calcBmi[indexPath.row].dateIncluded, user_Weight: Double(self.newWeight.text!)!, user_bmiResult: finalBMICalculation)
                    //calling the screen again
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "listViewController") as? ListViewController else {
                        print("couldn't find the view controller")
                        return
                    }
                    self.navigationController?.pushViewController(destinationViewController, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                   //calling the screen again
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "listViewController") as? ListViewController else {
                        print("couldn't find the view controller")
                        return
                    }
                    self.navigationController?.pushViewController(destinationViewController, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        updateAction.backgroundColor = UIColor.blue

        let swipeActions = UISwipeActionsConfiguration(actions: [updateAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {

     let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in


        self.database.delete(user_Name: self.calcBmi[indexPath.row].name, date_Included: self.calcBmi[indexPath.row].dateIncluded, user_Weight: self.calcBmi[indexPath.row].weight)
         
        self.calcBmi = self.database.query()
         
         tableView.beginUpdates()
         tableView.deleteRows(at: [indexPath],with: .automatic)
         tableView.endUpdates()
     }
     let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
     return swipeActions
    }
}
