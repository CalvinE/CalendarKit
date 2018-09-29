//
//  CalendarControl.swift
//  CalendarKit
//
//  Created by calvin echols on 9/27/18.
//  Copyright © 2018 Strong Link Solutions. All rights reserved.
//

import UIKit

@IBDesignable
class UICalendar: UIControl {
    
    private let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private let weekDays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"]
    private let numDays: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    private var calendarSV: UIStackView? = nil
    private var monthLabel: UILabel? = nil
    
    private var weeksSV: UIStackView? = nil
    
    private var sundaySV: UIStackView? = nil
    private var mondaySV: UIStackView? = nil
    private var tuesdaySV: UIStackView? = nil
    private var wednesdaySV: UIStackView? = nil
    private var thursdaySV: UIStackView? = nil
    private var fridaySV: UIStackView? = nil
    private var saturdaySV: UIStackView? = nil
    
    private var dateButtons: [UIButton] = []
    
    private var dates: [Date] = []
    
    private let dateFormatter = DateFormatter()
    
    @IBInspectable
    var headerBackgroundColor: UIColor = UIColor.white {
        didSet {
            monthLabel?.backgroundColor = headerBackgroundColor
        }
    }
    
    @IBInspectable
    var headerColor: UIColor = UIColor.black {
        didSet {
            monthLabel?.textColor = headerColor
        }
    }
    
    @IBInspectable
    var cellBackgroundColor: UIColor = UIColor.white {
        didSet {
            for btn in dateButtons {
                if (btn.isEnabled) {
                    btn.backgroundColor = cellBackgroundColor
                }
            }
        }
    }
    
    @IBInspectable
    var cellBackgroundColorDisabled: UIColor = UIColor.darkGray {
        didSet {
            for btn in dateButtons {
                if (btn.isEnabled == false) {
                    btn.backgroundColor = cellBackgroundColorDisabled
                }
            }
        }
    }
    
    @IBInspectable
    var cellColor: UIColor = UIColor.darkGray {
        didSet {
            for btn in dateButtons {
                btn.setTitleColor(cellColor, for: .normal)
            }
        }
    }
    
    @IBInspectable
    var cellColorDisabled: UIColor = UIColor.lightGray {
        didSet {
            for btn in dateButtons {
                btn.setTitleColor(cellColorDisabled, for: .disabled)
            }
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 2.0
            calendarSV?.layer.borderColor = borderColor.cgColor
            calendarSV?.layer.borderWidth = 1
            monthLabel?.layer.borderColor = borderColor.cgColor
            monthLabel?.layer.borderWidth = 1.0
            
        }
    }
    
    @IBInspectable
    var showCellSeperators: Bool = false {
        didSet {
            for btn in dateButtons {
                if (showCellSeperators) {
                    btn.layer.borderColor = borderColor.cgColor
                    btn.layer.borderWidth = 1.0
                } else {
                    btn.layer.borderColor = UIColor.clear.cgColor
                    btn.layer.borderWidth = 0.0
                }
            }
        }
    }
    
    var date: Date = Date() {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        dates = []
        calendarSV = UIStackView()
        addSubview(calendarSV!)
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        monthLabel = UILabel()
        monthLabel!.text = months[month-1]
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
        applyStyling()
    }
    
    func buildMonthDateStackViews(month: Int, year: Int) -> [UIStackView] {
        
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
        
        //Account for leap years
//        if (month == 2 && ((year % 4 == 0 && year % 100 == 0) || year % 400 == 0)) {
//
//        }
        
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
        
        for _ in lastWeekDayPopulated...7 { //Populate days visible on calendar after the current month.
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
    
    func applyStyling() {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2.0
        self.accessibilityIdentifier = "CalendarControl"
        self.translatesAutoresizingMaskIntoConstraints = true
        
        monthLabel!.layer.borderColor = borderColor.cgColor
        monthLabel!.layer.borderWidth = 1.0
        monthLabel!.textAlignment = .center
        monthLabel!.textColor = headerColor
        monthLabel!.backgroundColor = headerBackgroundColor
        monthLabel!.accessibilityIdentifier = "monthLabel"
        monthLabel!.translatesAutoresizingMaskIntoConstraints = false
        monthLabel!.centerXAnchor.constraint(equalTo: calendarSV!.centerXAnchor).isActive = true
        monthLabel!.topAnchor.constraint(equalTo: calendarSV!.topAnchor).isActive = true
        monthLabel!.widthAnchor.constraint(equalTo: calendarSV!.widthAnchor, multiplier: 1).isActive = true
        monthLabel!.heightAnchor.constraint(equalTo: calendarSV!.heightAnchor, multiplier: 0.125).isActive = true
        
        weeksSV!.accessibilityIdentifier = "weeksSV"
        weeksSV!.axis = .horizontal
        weeksSV!.distribution = .fillEqually
        weeksSV!.alignment = .center
        weeksSV!.translatesAutoresizingMaskIntoConstraints = false
        weeksSV!.bottomAnchor.constraint(equalTo: calendarSV!.bottomAnchor).isActive = true
        weeksSV!.leftAnchor.constraint(equalTo: calendarSV!.leftAnchor).isActive = true
        weeksSV!.rightAnchor.constraint(equalTo: calendarSV!.rightAnchor).isActive = true
        weeksSV!.topAnchor.constraint(equalTo: monthLabel!.bottomAnchor).isActive = true
        
        sundaySV!.accessibilityIdentifier = "sundaySV"
        sundaySV!.axis = .vertical
        sundaySV!.distribution = .fillEqually
        sundaySV!.alignment = .fill
        sundaySV!.spacing = 0
        sundaySV!.translatesAutoresizingMaskIntoConstraints = false
        sundaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        sundaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true

        mondaySV!.accessibilityIdentifier = "mondaySV"
        mondaySV!.axis = .vertical
        mondaySV!.distribution = .fillEqually
        mondaySV!.alignment = .fill
        mondaySV!.spacing = 0
        mondaySV!.translatesAutoresizingMaskIntoConstraints = false
        mondaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        mondaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true

        tuesdaySV!.accessibilityIdentifier = "tuesdaySV"
        tuesdaySV!.axis = .vertical
        tuesdaySV!.distribution = .fillEqually
        tuesdaySV!.alignment = .fill
        tuesdaySV!.spacing = 0
        tuesdaySV!.translatesAutoresizingMaskIntoConstraints = false
        tuesdaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        tuesdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true

        wednesdaySV!.accessibilityIdentifier = "wednesdaySV"
        wednesdaySV!.axis = .vertical
        wednesdaySV!.distribution = .fillEqually
        wednesdaySV!.alignment = .fill
        wednesdaySV!.spacing = 0
        wednesdaySV!.translatesAutoresizingMaskIntoConstraints = false
        wednesdaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        wednesdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true

        thursdaySV!.accessibilityIdentifier = "thursdaySV"
        thursdaySV!.axis = .vertical
        thursdaySV!.distribution = .fillEqually
        thursdaySV!.alignment = .fill
        thursdaySV!.spacing = 0
        thursdaySV!.translatesAutoresizingMaskIntoConstraints = false
        thursdaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        thursdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true

        fridaySV!.accessibilityIdentifier = "fridaySV"
        fridaySV!.axis = .vertical
        fridaySV!.distribution = .fillEqually
        fridaySV!.alignment = .fill
        fridaySV!.spacing = 0
        fridaySV!.translatesAutoresizingMaskIntoConstraints = false
        fridaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        fridaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true

        saturdaySV!.accessibilityIdentifier = "saturdaySV"
        saturdaySV!.axis = .vertical
        saturdaySV!.distribution = .fillEqually
        saturdaySV!.alignment = .fill
        saturdaySV!.spacing = 0
        saturdaySV!.translatesAutoresizingMaskIntoConstraints = false
        saturdaySV!.topAnchor.constraint(equalTo: weeksSV!.topAnchor).isActive = true
        saturdaySV!.bottomAnchor.constraint(equalTo: weeksSV!.bottomAnchor).isActive = true
        
        calendarSV!.layer.borderColor = borderColor.cgColor
        calendarSV!.layer.borderWidth = 1.0
        calendarSV!.accessibilityIdentifier = "calendarSV"
        calendarSV!.axis = .vertical
        calendarSV!.translatesAutoresizingMaskIntoConstraints = false
        calendarSV!.backgroundColor = UIColor.blue
        calendarSV!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        calendarSV!.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        calendarSV!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        calendarSV!.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    func makeDateButton(date: Int, month: Int, year: Int, isEnabled: Bool, isVisible: Bool) -> UIButton {
        let dateBtn: UIButton = UIButton()
        dateBtn.setTitle("\(date)", for: (isEnabled == true) ? .normal : .disabled)
        dateBtn.backgroundColor = (isEnabled) ? cellBackgroundColor : cellBackgroundColorDisabled
        dateBtn.setTitleColor(cellColor, for: .normal)
        dateBtn.setTitleColor(cellColorDisabled, for: .disabled)
        dateBtn.translatesAutoresizingMaskIntoConstraints = true
        dateBtn.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        dateBtn.isEnabled = isEnabled
        dateBtn.isHidden = !isVisible
        dateBtn.layer.masksToBounds = true
        if (showCellSeperators) {
            dateBtn.layer.borderColor = borderColor.cgColor
            dateBtn.layer.borderWidth = 1.0
        } else {
            dateBtn.layer.borderColor = UIColor.clear.cgColor
            dateBtn.layer.borderWidth = 0.0
        }
        dateBtn.tag = dates.count
        dates.append(dateFormatter.date(from: "\(year)-\(month)-\(date)")!)
        dateButtons.append(dateBtn)
        dateBtn.addTarget(self, action: #selector(onBtnTapped), for: .touchUpInside)
        return dateBtn
    }
    
    @objc func onBtnTapped(sender: UIButton) {
        print(dates[sender.tag])
        date = dates[sender.tag]
        self.sendActions(for: .valueChanged)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.date = Date()
    }

}
