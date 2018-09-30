//
//  ViewController.swift
//  CalendarKit
//
//  Created by calvin echols on 9/27/18.
//  Copyright © 2018 Strong Link Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var calendarControl: UICalendar!
    
    var dateFormatter: DateFormatter = DateFormatter()
    var date: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "d-M-yyyy"
    }

    @IBAction func calendarValueChanged(_ sender: Any) {
        date = (sender as! UICalendar).selectedDate ?? Date()
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @IBAction func prevBtnTapped(_ sender: Any) {
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        calendarControl.set(date: date)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        calendarControl.set(date: date)
    }
    
}

