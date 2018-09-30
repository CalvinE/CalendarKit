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
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeLeft.direction = .left
        calendarControl.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeRight.direction = .right
        calendarControl.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(swipe: UISwipeGestureRecognizer) {
        switch(swipe.direction) {
            case UISwipeGestureRecognizer.Direction.left:
                calendarControl.changeMonthBy(numberOfMonths: 1)
            default:
                calendarControl.changeMonthBy(numberOfMonths: -1)
        }
    }

    @IBAction func calendarValueChanged(_ sender: Any) {
        date = (sender as! UICalendar).selectedDate ?? Date()
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @IBAction func prevBtnTapped(_ sender: Any) {
        calendarControl.changeMonthBy(numberOfMonths: -1)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        calendarControl.changeMonthBy(numberOfMonths: 1)
    }
    
}

