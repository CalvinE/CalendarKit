//
//  CalendarControl.swift
//  CalendarKit
//
//  Created by calvin echols on 9/27/18.
//  Copyright © 2018 Strong Link Solutions. All rights reserved.
//

import UIKit

@IBDesignable
class CalendarControl: UIView {
    
    private let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private let weekDays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"]
    private let numDays: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var calendarSV: UIStackView? = nil
    var monthLabel: UILabel? = nil
    
    var weeksSV: UIStackView? = nil
    
    var sundaySV: UIStackView? = nil
    var mondaySV: UIStackView? = nil
    var tuesdaySV: UIStackView? = nil
    var wednesdaySV: UIStackView? = nil
    var thursdaySV: UIStackView? = nil
    var fridaySV: UIStackView? = nil
    var saturdaySV: UIStackView? = nil
    
    @IBInspectable
    var headerBackgroundColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var headerColor: UIColor = UIColor.black {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var cellBackgroundColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var cellBackgroundColorDisabled: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var cellColor: UIColor = UIColor.darkGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var cellColorDisabled: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var cellSeperatorColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    var date: Date = Date() {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        calendarSV = UIStackView()
        addSubview(calendarSV!)
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        monthLabel = UILabel()
        monthLabel!.text = months[month-1]
        monthLabel!.textAlignment = .center
        monthLabel!.textColor = headerColor
        monthLabel!.backgroundColor = headerBackgroundColor
        calendarSV!.addSubview(monthLabel!)
        
        sundaySV = UIStackView()
        mondaySV = UIStackView()
        tuesdaySV = UIStackView()
        wednesdaySV = UIStackView()
        thursdaySV = UIStackView()
        fridaySV = UIStackView()
        saturdaySV = UIStackView()
        
        weeksSV = UIStackView(arrangedSubviews: buildMonthDateStackViews(month: month, year: year))
        calendarSV!.addSubview(weeksSV!)
        applyConstraints()
    }
    
    func buildMonthDateStackViews(month: Int, year: Int) -> [UIStackView] {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        let date = dateFormatter.date(from: "\(year)-\(month)-1")
        let weekDayOfTheFirst: Int = Calendar.current.component(.weekday, from: date!)
        
        let prevMonth: Int = (month == 1) ? 12 : month - 1
        let prevMonthYear: Int = (prevMonth == 12) ? year - 1 : year
        let prevMonthNumDays: Int = numDays[prevMonth-1]
        
        let nextMonth: Int = (month == 12) ? 1 : month + 1
        let nextMonthYear: Int = (month == 1) ? year + 1 : year
//        let nextMonthNumDays: Int = numDays[nextMonth-1]
        
        var lastWeekDayPopulated: Int = 1;
        
        for n in 1...weekDayOfTheFirst - 1 {//Populate buttons on calendar that are from the previous month.
            let date: Int = prevMonthNumDays - weekDayOfTheFirst + n + 1
            var dayOfWeekSV: UIStackView? = nil
            switch (lastWeekDayPopulated%7) {
            case 1: //Sunday
                dayOfWeekSV = sundaySV
            case 2: //Monday
                dayOfWeekSV = mondaySV
            case 3: //Tuesday
                dayOfWeekSV = tuesdaySV
            case 4: //Wednesday
                dayOfWeekSV = wednesdaySV
            case 5: //Thursday
                dayOfWeekSV = thursdaySV
            case 6: //Friday
                dayOfWeekSV = fridaySV
            default: // Saturday
                dayOfWeekSV = saturdaySV
            }
            dayOfWeekSV!.addArrangedSubview(makeDateButton(date: date, month: prevMonth, year: prevMonthYear, isEnabled: false, isVisible: true))
            lastWeekDayPopulated = lastWeekDayPopulated + 1
            if (lastWeekDayPopulated > 7) {
                lastWeekDayPopulated = 1
            }
        }
        
        for n in 1...numDays[month-1] {
            var dayOfWeekSV: UIStackView? = nil
            switch (lastWeekDayPopulated%7) {
            case 1: //Sunday
                dayOfWeekSV = sundaySV
            case 2: //Monday
                dayOfWeekSV = mondaySV
            case 3: //Tuesday
                dayOfWeekSV = tuesdaySV
            case 4: //Wednesday
                dayOfWeekSV = wednesdaySV
            case 5: //Thursday
                dayOfWeekSV = thursdaySV
            case 6: //Friday
                dayOfWeekSV = fridaySV
            default: // Saturday
                dayOfWeekSV = saturdaySV
            }
            dayOfWeekSV!.addArrangedSubview(makeDateButton(date: n, month: month, year: year, isEnabled: true, isVisible: true))
            lastWeekDayPopulated = lastWeekDayPopulated + 1
            if (lastWeekDayPopulated > 7) {
                lastWeekDayPopulated = 1
            }
        }
        
        var nextDate: Int = 1
        
        for n in lastWeekDayPopulated...7 { //Populate days visible on calendar after the current month.
            var dayOfWeekSV: UIStackView? = nil
            switch (lastWeekDayPopulated%7) {
            case 1: //Sunday
                dayOfWeekSV = sundaySV
            case 2: //Monday
                dayOfWeekSV = mondaySV
            case 3: //Tuesday
                dayOfWeekSV = tuesdaySV
            case 4: //Wednesday
                dayOfWeekSV = wednesdaySV
            case 5: //Thursday
                dayOfWeekSV = thursdaySV
            case 6: //Friday
                dayOfWeekSV = fridaySV
            default: // Saturday
                dayOfWeekSV = saturdaySV
            }
            dayOfWeekSV!.addArrangedSubview(makeDateButton(date: nextDate, month: nextMonth, year: nextMonthYear, isEnabled: false, isVisible: true))
            nextDate += 1
            lastWeekDayPopulated = lastWeekDayPopulated + 1
            if (lastWeekDayPopulated > 7) {
                lastWeekDayPopulated = 1
            }
        }
        
        return [sundaySV!, mondaySV!, tuesdaySV!, wednesdaySV!, thursdaySV!, fridaySV!, saturdaySV!]
    }
    
    func applyConstraints() {
        monthLabel!.translatesAutoresizingMaskIntoConstraints = false
        monthLabel!.centerXAnchor.constraint(equalTo: calendarSV!.centerXAnchor).isActive = true
        monthLabel!.topAnchor.constraint(equalTo: calendarSV!.topAnchor).isActive = true
        monthLabel!.widthAnchor.constraint(equalTo: calendarSV!.widthAnchor, multiplier: 1).isActive = true
        monthLabel!.heightAnchor.constraint(equalTo: calendarSV!.heightAnchor, multiplier: 0.125).isActive = true
        
        weeksSV!.axis = .horizontal
        weeksSV!.distribution = .fillEqually
        weeksSV!.alignment = .center
        weeksSV!.translatesAutoresizingMaskIntoConstraints = false
        weeksSV!.bottomAnchor.constraint(equalTo: calendarSV!.bottomAnchor).isActive = true
        weeksSV!.leftAnchor.constraint(equalTo: calendarSV!.leftAnchor).isActive = true
        weeksSV!.rightAnchor.constraint(equalTo: calendarSV!.rightAnchor).isActive = true
        weeksSV!.topAnchor.constraint(equalTo: monthLabel!.bottomAnchor).isActive = true
        weeksSV!.heightAnchor.constraint(equalTo: calendarSV!.heightAnchor, multiplier: 1-0.125).isActive = true
        
        sundaySV!.axis = .vertical
        sundaySV!.distribution = .fillEqually
        sundaySV!.alignment = .fill
        sundaySV!.spacing = 1
        sundaySV!.translatesAutoresizingMaskIntoConstraints = false
        sundaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        sundaySV!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        sundaySV!.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        sundaySV!.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/7).isActive = true
//        sundaySV!.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true

        mondaySV!.axis = .vertical
        mondaySV!.distribution = .fillEqually
        mondaySV!.alignment = .fill
        mondaySV!.spacing = 1
        mondaySV!.translatesAutoresizingMaskIntoConstraints = false
        mondaySV!.topAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
        mondaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
//        mondaySV!.leftAnchor.constraint(equalTo: sundaySV!.leftAnchor).isActive = true
//        mondaySV!.widthAnchor.constraint(equalTo: weeksSV!.widthAnchor, multiplier: 1/7).isActive = true

        tuesdaySV!.axis = .vertical
        tuesdaySV!.distribution = .fillEqually
        tuesdaySV!.alignment = .fill
        tuesdaySV!.spacing = 1
        tuesdaySV!.translatesAutoresizingMaskIntoConstraints = false
        tuesdaySV!.topAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
        tuesdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
//        tuesdaySV!.leftAnchor.constraint(equalTo: mondaySV.leftAnchor).isActive = true
//        tuesdaySV!.widthAnchor.constraint(equalTo: weeksSV!.widthAnchor, multiplier: 1/7).isActive = true

        wednesdaySV!.axis = .vertical
        wednesdaySV!.distribution = .fillEqually
        wednesdaySV!.alignment = .fill
        wednesdaySV!.spacing = 1
        wednesdaySV!.translatesAutoresizingMaskIntoConstraints = false
        wednesdaySV!.topAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
        wednesdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
//        wednesdaySV!.leftAnchor.constraint(equalTo: tuesdaySV!.leftAnchor).isActive = true
//        wednesdaySV!.widthAnchor.constraint(equalTo: weeksSV!.widthAnchor, multiplier: 1/7).isActive = true

        thursdaySV!.axis = .vertical
        thursdaySV!.distribution = .fillEqually
        thursdaySV!.alignment = .fill
        thursdaySV!.spacing = 1
        thursdaySV!.translatesAutoresizingMaskIntoConstraints = false
        thursdaySV!.topAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
        thursdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
//        thursdaySV!.leftAnchor.constraint(equalTo: wednesdaySV!.leftAnchor).isActive = true
//        thursdaySV!.widthAnchor.constraint(equalTo: weeksSV!.widthAnchor, multiplier: 1/7).isActive = true

        fridaySV!.axis = .vertical
        fridaySV!.distribution = .fillEqually
        fridaySV!.alignment = .fill
        fridaySV!.spacing = 1
        fridaySV!.translatesAutoresizingMaskIntoConstraints = false
        fridaySV!.topAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
        fridaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
//        fridaySV!.leftAnchor.constraint(equalTo: thursdaySV!.leftAnchor).isActive = true
//        fridaySV!.widthAnchor.constraint(equalTo: weeksSV!.widthAnchor, multiplier: 1/7).isActive = true

        saturdaySV!.axis = .vertical
        saturdaySV!.distribution = .fillEqually
        saturdaySV!.alignment = .fill
        saturdaySV!.spacing = 1
        saturdaySV!.translatesAutoresizingMaskIntoConstraints = false
        saturdaySV!.topAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
        saturdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
//        saturdaySV!.leftAnchor.constraint(equalTo: fridaySV!.leftAnchor).isActive = true
//        saturdaySV!.widthAnchor.constraint(equalTo: weeksSV!.widthAnchor, multiplier: 1/7).isActive = true
        
        calendarSV!.axis = .vertical
        calendarSV!.translatesAutoresizingMaskIntoConstraints = false
        calendarSV!.backgroundColor = UIColor.blue
        calendarSV!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        calendarSV!.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        calendarSV!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        calendarSV!.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    func makeDateButton(date: Int, month: Int, year: Int, isEnabled: Bool, isVisible: Bool) -> UIButton {
        let dateBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        dateBtn.setTitle("\(date)", for: (isEnabled == true) ? .normal : .disabled)
        dateBtn.backgroundColor = (isEnabled) ? cellBackgroundColor : cellBackgroundColorDisabled
        dateBtn.setTitleColor(cellColor, for: .normal)
        dateBtn.setTitleColor(cellColorDisabled, for: .disabled)
        dateBtn.translatesAutoresizingMaskIntoConstraints = false
        dateBtn.isEnabled = isEnabled
        dateBtn.isHidden = !isVisible
//        dateBtn.contentMode = .scaleAspectFill
//        dateBtn.setValue("\(year)-\(month)-\(date)", forKey: "value")
//        print(dateBtn.value(forKey: "value"))
        return dateBtn
    }
    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        
//        self.headerBackgroundColor = UIColor.white
//        
//        self.headerColor = UIColor.black
//        
//        self.cellBackgroundColor = UIColor.white
//        
//        self.cellBackgroundColorDisabled = UIColor.white
//        
//        self.cellColor = UIColor.darkGray
//        
//        self.cellColorDisabled = UIColor.lightGray
//        
//        self.cellSeperatorColor = UIColor.clear
//        
//        self.date = Date()
//    }
}
