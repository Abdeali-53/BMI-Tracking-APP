//
//  Database.swift
//  BMI_Tracking_App
//
//  Created by Abdeali Mody on 2020-12-11.
//  Student ID - 301085484
//  Version 1.0
//  Copyright © 2020 Abdeali. All rights reserved.

import Foundation

class Database
{
  //Initializing a database
  init()
  {
      database = openDatabase()
      createTable()
  }
  //Opening a Database
  var database:OpaquePointer?
  func openDatabase() -> OpaquePointer?
  {
      var database: OpaquePointer? = nil
      if sqlite3_open(filePath(), &database) != SQLITE_OK
      {
          sqlite3_close(database)
          print("error opening db")
          return nil
      }
      else
      {
          print("Opened connection to database")
          return database
      }
  }

  //Creating a table inside Database.
  func createTable()
  {
      let createTableString = "CREATE TABLE IF NOT EXISTS BMI_TRACKING " +
                              "( user_Name CHAR(100), " +
                              "  user_Age CHAR(5), " +
                              "  user_Gender CHAR(20), " +
                              "  user_calculationType INT, " +
                              "  user_Weight DOUBLE , " +
                              "  user_Height DOUBLE, " +
                              "  user_bmiResult DOUBLE , " +
                              "  date_Included CHAR(20) );"
      var createTableStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
      {
          if sqlite3_step(createTableStatement) == SQLITE_DONE
          {
              print("bmi_tracking table created.")
          }
          else
          {
              print("bmi_tracking table could not be created.")
          }
      }
      else
      {
          print("create bmi_tracking table statement could not be prepared.")
      }
      sqlite3_finalize(createTableStatement)
  }

  //Inserting Row inside a Table.
  func insert(user_Name: String, user_Age: String, user_Gender: String, user_calculationType: Int, user_Weight: Double, user_Height: Double, user_bmiResult: Double, date_Included: String)
  {

      let insertStatementString = "INSERT INTO BMI_TRACKING (user_Name, user_Age, user_Gender, user_calculationType, user_Weight, user_Height, user_bmiResult, date_Included) VALUES ( ? , ? , ? , ? , ? , ? , ? , ? );"
      var insertStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
      {
          sqlite3_bind_text(insertStatement, 1, (user_Name as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, 2, (user_Age as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, 3, (user_Gender as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, 4, (String(user_calculationType) as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, 5, (String(user_Weight) as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, 6, (String(user_Height) as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, 7, (String(user_bmiResult) as NSString).utf8String, -1, nil)
          sqlite3_bind_text(insertStatement, 8, (date_Included as NSString).utf8String, -1, nil)
          
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                print("inserted row.")
            }
            else
            {
                print("Could not insert row.")
            }
      }
      else
      {
          print("insert bmi_tracking statement could not be prepared.")
      }
      sqlite3_finalize(insertStatement)
  }

    //Updating Record inside a row.
    func update( user_Name: String, date_Included: String, user_Weight:Double, user_bmiResult: Double)
    {

        let updateStatementString = "UPDATE bmi_tracking SET user_Weight = ? , user_bmiResult = ?   WHERE date_Included = ? AND user_Name = ? ;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (String(user_Weight) as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (String(user_bmiResult) as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (date_Included as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (user_Name as NSString).utf8String, -1, nil)
           
            if sqlite3_step(updateStatement) == SQLITE_DONE
            {
                print("updated row.")
            }
            else
            {
                print("Could not update row.")
            }
        }
        else
        {
            print("Update bmi_tracking statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }

    //Query Function
    func query() -> [Calculations]
    {
      let queryStatementString = "SELECT user_Name, user_Age, user_Gender, user_calculationType, user_Weight, user_Height, user_bmiResult, date_Included FROM bmi_tracking  "
      var queryStatement: OpaquePointer? = nil
      var calcInfo : [Calculations] = []
      if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
      {
         
          while sqlite3_step(queryStatement) == SQLITE_ROW
          {
            let user_Name = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
            let user_Age = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
            let user_Gender = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
            let user_calculationType = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
            let user_Weight = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 4))))
            let user_Height = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 5))))
            let user_bmiResult = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 6))))
            let date_Included = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
            
            calcInfo.append(Calculations(name: user_Name, age: user_Age, gender: user_Gender, isMetric: (user_calculationType == "0" ? true : false), weight: user_Weight!, height: user_Height!, finalBMICalculation: user_bmiResult!, dateIncluded: date_Included))
           
            print("Query Result:")
            print("\(user_Name)  ")
          }
      }
      else
      {
          print("select bmi_tracking statement could not be prepared")
      }
      sqlite3_finalize(queryStatement)
      return calcInfo
  }
  
  //This function is used to delete a row from the table.
  func delete(user_Name: String, date_Included: String, user_Weight:Double)
  {
      let deleteStatementStirng = "DELETE FROM bmi_tracking WHERE user_Name = ? and date_Included = ? and user_Weight = ? ;"
      var deleteStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(database, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK
      {
        sqlite3_bind_text(deleteStatement, 1, (user_Name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(deleteStatement, 2, (date_Included as NSString).utf8String, -1, nil)
        sqlite3_bind_text(deleteStatement, 3, (String(user_Weight) as NSString).utf8String, -1, nil)
          
        if sqlite3_step(deleteStatement) == SQLITE_DONE
        {
            print("deleted row.")
        }
        else
        {
            print("Could not delete row.")
        }
      }
      else
      {
          print("delete bmi_traking statement could not be prepared")
      }
      sqlite3_finalize(deleteStatement)
  }

  //This function is used for providing file path.
  func filePath() -> String
  {
          let urls = FileManager.default.urls(for:
              .documentDirectory, in: .userDomainMask)
          var url:String?
          url = urls.first?.appendingPathComponent("data.plist").path
          return url!
  }
}
