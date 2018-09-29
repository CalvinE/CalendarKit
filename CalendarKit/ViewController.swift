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
    var dateFormatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "d-M-yyyy"
    }

    @IBAction func calendarValueChanged(_ sender: Any) {
        dateLabel.text = dateFormatter.string(from: (sender as! UICalendar).selectedDate ?? Date())
    }
    
}

