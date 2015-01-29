//
//  ViewController.swift
//  Budget
//
//  Created by Rohan Kapoor on 12/28/14.
//  Copyright (c) 2014 FBGM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var budget: UITextField! //number (with decimal) field for budget
    @IBOutlet weak var days: UITextField! //nummber (without decimal) field for budget
    
    @IBOutlet weak var dailyAmtRem: UILabel! //label for today's amount remaining
    
    @IBOutlet weak var lastExpenditure: UITextField! //number (with decimal) field for last expenditure
    
    @IBOutlet weak var extraSavings: UILabel! //label for extra savings
    @IBOutlet weak var dailyAmount: UILabel! //label for constant daily amount
    @IBOutlet weak var daysRemaining: UILabel! //label for days remaining
    
    @IBOutlet weak var date: UILabel! //label for the refresh/get date button
    
    @IBOutlet weak var startDate: UILabel! //label for the constant start date
    
    //helper function that returns an int of the amount of days between the starting date and a chosen date seen through clicking the refresh/get date button
    func getNumDays(startDate:NSDate, endDate:NSDate) -> NSInteger
    {
        
        var cal: NSCalendar = NSCalendar.currentCalendar();
        let comp = cal.components(NSCalendarUnit.DayCalendarUnit, fromDate: startDate, toDate: endDate, options: nil)
        return comp.day
    }
    
    //helper funciton that returns a double with only two spaces after a decimal
    func leaveTwoDecSpaces(num: Double) -> Double
    {
        var doubleString = String(format:"%f",num)
        var count = 0
        for i in doubleString
        {
            if(i == ".")
            {
                doubleString = doubleString.substringToIndex(advance(doubleString.startIndex, count + 3))
            }
            count++
        }
        return (doubleString as NSString).doubleValue
    }
    
    //refresh/get date function that gets the current date/time and checks to see if the current date is different from the starting date... updates accordingly
    @IBAction func getDate(sender: AnyObject)
    {
        var dailyAmountRemNum: Double =  (dailyAmtRem.text! as NSString).doubleValue
        var extraSavingsNum: Double = (extraSavings.text! as NSString).doubleValue
        var dailyAmountNum: Double = (dailyAmount.text! as NSString).doubleValue
        var numDays = days.text.toInt()
        var budgetValue: Double = (budget.text as NSString).doubleValue
        
        //refreshes the date
        let currentDate = NSDate()
        let fix = NSDateFormatter()
        if(numDays > 0 && budgetValue > 0)
        {
            fix.timeStyle = NSDateFormatterStyle.MediumStyle
            fix.dateStyle = NSDateFormatterStyle.MediumStyle
            fix.timeZone = NSTimeZone()
            date.text = fix.stringFromDate(currentDate)
        }
        
        //refreshes all the necessary info if the date is different from the starting date
        if(date != startDate)
        {
            //updates the extra savings and the daily amount remaining
            extraSavingsNum += dailyAmountRemNum
            dailyAmountRemNum = dailyAmountNum
            
            //formats the starting date into an NSDate()
            let startDateFormatter = NSDateFormatter()
            startDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
            let beginDate = startDateFormatter.dateFromString(startDate.text!)
            
            //updates the days remaining
            var daysInBetween: Int = getNumDays(beginDate!,endDate: currentDate)
            var daysRemInt = daysRemaining?.text?.toInt()
            if(daysRemInt! - daysInBetween > 0)
            {
                daysRemInt! -= daysInBetween
            }
            else
            {
                daysRemInt = 0
            }
            
            daysRemaining.text = String(daysRemInt!)
            extraSavings.text = String(format:"%f", extraSavingsNum)
            dailyAmtRem.text = String(format:"%f", dailyAmountRemNum)
        }
        
    }
    
    //function for entering the information into the budget and spending period text fields
    @IBAction func enterStartingData(sender: AnyObject)
    {
        //converts days into an int and budget into a double
        var numDays = days.text.toInt()
        var budgetValue: Double = (budget.text as NSString).doubleValue
        
        //function only runs if valid info is passed
        if(numDays > 0 && budgetValue > 0)
        {
            //makes sure all doubles only hold 2 spaces after the decimal
            var dailyAmountRemNum: Double = leaveTwoDecSpaces(budgetValue/Double(numDays!))
            var dailyAmountNum: Double = leaveTwoDecSpaces(budgetValue/Double(numDays!))
            
            dailyAmtRem.text = String(format:"%f", dailyAmountRemNum)
            dailyAmount.text = String(format:"%f", dailyAmountNum)
            daysRemaining.text = String(numDays!)
        
        
            var extraSavingsNum: Double = (extraSavings.text! as NSString).doubleValue
            extraSavingsNum = 0
            extraSavings.text = String(format:"%f", extraSavingsNum)
        
            getDate(budget)
           
            //startDate = date.copy() as UILabel
            
            //makes the keyboard disappear once valid info is typed into the fields
            budget.resignFirstResponder()
            days.resignFirstResponder()
        }
    }
    
    @IBAction func enterLastExpenditure(sender: AnyObject)
    {
        var numDays = days.text.toInt()
        var budgetValue: Double = (budget.text as NSString).doubleValue
        
        if(numDays > 0 && budgetValue > 0)
        {
            var expendNum: Double = (lastExpenditure.text as NSString).doubleValue
            var dailyAmountRemNum: Double =  (dailyAmtRem.text! as NSString).doubleValue
            var extraSavingsNum: Double = (extraSavings.text! as NSString).doubleValue
            
            dailyAmountRemNum -= expendNum
        
            if(dailyAmountRemNum < 0)
            {
                extraSavingsNum += dailyAmountRemNum
                dailyAmountRemNum = 0
            }
        
            lastExpenditure.text = String(format:"%f", 0.00)
            dailyAmtRem.text = String(format:"%f", dailyAmountRemNum)
            extraSavings.text = String(format:"%f", extraSavingsNum)
            lastExpenditure.resignFirstResponder()
            getDate(budget)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        budget.resignFirstResponder()
        days.resignFirstResponder()
        lastExpenditure.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

