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
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeUp.direction = .up
        calendarControl.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeDown.direction = .down
        calendarControl.addGestureRecognizer(swipeDown)
    }
    
    override func viewDidAppear(_ animated: Bool) {        
//        calendarControl.selectionStyle = .Underline
    }
    
    @objc private func handleSwipe(swipe: UISwipeGestureRecognizer) {
        switch(swipe.direction) {
            case UISwipeGestureRecognizer.Direction.left:
                calendarControl.changeDateBy(numberOfMonths: 1)
            case UISwipeGestureRecognizer.Direction.up:
                calendarControl.changeDateBy(numberOfYears: 1)
            case UISwipeGestureRecognizer.Direction.down:
                calendarControl.changeDateBy(numberOfYears: -1)
            default:
                calendarControl.changeDateBy(numberOfMonths: -1)
        }
    }

    @IBAction func calendarValueChanged(_ sender: Any) {
        date = (sender as! UICalendar).selectedDate ?? Date()
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @IBAction func prevBtnTapped(_ sender: Any) {
        calendarControl.changeDateBy(numberOfMonths: -1)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        calendarControl.changeDateBy(numberOfMonths: 1)
    }
    
}

