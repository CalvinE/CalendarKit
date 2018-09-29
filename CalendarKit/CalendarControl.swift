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
    
    private var dateButtonMetadata: [DateButtonMetadata] = []
    
    private let dateFormatter = DateFormatter()
    
    private var weekDayOfTheFirst: Int = 0
    private var currentMonth: Int = 0
    private var currentYear: Int = 0
    
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
    var headerFont: UIFont = UIFont.boldSystemFont(ofSize: 20.0) {
        didSet{
            monthLabel?.font = headerFont
        }
    }
    
    @IBInspectable
    var cellBackgroundColor: UIColor = UIColor.white {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var cellColor: UIColor = UIColor.darkGray {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var cellFont: UIFont = UIFont.boldSystemFont(ofSize: 20.0) {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var cellColorDisabled: UIColor = UIColor.lightGray {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var cellBackgroundColorDisabled: UIColor = UIColor.white {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var cellBackgroundColorForDaysNotInCurrentMonth: UIColor = UIColor.white {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var cellFontForDaysNotInCurrentMonth: UIFont = UIFont.systemFont(ofSize: 20.0) {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
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
    
    @IBInspectable
    var enableSundays: Bool = true {
        didSet {
//            changeSateEnabledStateBy(dayOfTheWeek: 1, isEnabled: enableSundays)
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var enableMondays: Bool = true {
        didSet {
//            changeSateEnabledStateBy(dayOfTheWeek: 2, isEnabled: enableMondays)
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var enableTuesdays: Bool = true {
        didSet {
//            changeSateEnabledStateBy(dayOfTheWeek: 3, isEnabled: enableTuesdays)
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var enableWednesdays: Bool = true {
        didSet {
//            changeSateEnabledStateBy(dayOfTheWeek: 4, isEnabled: enableWednesdays)
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var enableThursdays: Bool = true {
        didSet {
//            changeSateEnabledStateBy(dayOfTheWeek: 5, isEnabled: enableThursdays)
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var enableFridays: Bool = true {
        didSet {
//            changeSateEnabledStateBy(dayOfTheWeek: 6, isEnabled: enableFridays)
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var enableSaturdays: Bool = true {
        didSet {
//            changeSateEnabledStateBy(dayOfTheWeek: 7, isEnabled: enableSaturdays)
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    @IBInspectable
    var enableDaysNotInCurrentMonth: Bool = false {
        didSet {
            for i in 0...dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
    }
    
    private var date: Date = Date()
    
    var selectedDate: Date? = nil
    
    private func updateView() {
        dateButtonMetadata = []
        calendarSV = UIStackView()
        addSubview(calendarSV!)
        
        monthLabel = UILabel()
        monthLabel!.font = headerFont
        monthLabel!.text = months[currentMonth-1]
        
        calendarSV!.addSubview(monthLabel!)
        
        sundaySV = UIStackView()
        mondaySV = UIStackView()
        tuesdaySV = UIStackView()
        wednesdaySV = UIStackView()
        thursdaySV = UIStackView()
        fridaySV = UIStackView()
        saturdaySV = UIStackView()
        
        weeksSV = UIStackView(arrangedSubviews: buildMonthDateStackViews(month: currentMonth, year: currentYear))
        
        calendarSV!.addSubview(weeksSV!)
        
        applyStyling()
    }
    
    private func buildMonthDateStackViews(month: Int, year: Int) -> [UIStackView] {
        
        let prevMonth: Int = (month == 1) ? 12 : month - 1
        let prevMonthYear: Int = (prevMonth == 12) ? year - 1 : year
        let prevMonthNumDays: Int = getNumberOfDaysIn(month: prevMonth, year: prevMonthYear)
        
        let nextMonth: Int = (month == 12) ? 1 : month + 1
        let nextMonthYear: Int = (month == 1) ? year + 1 : year
        
        var lastWeekDayPopulated: Int = 1;
        
        for n in 1...weekDayOfTheFirst - 1 {//Populate buttons on calendar that are from the previous month.
            let date: Int = prevMonthNumDays - weekDayOfTheFirst + n + 1
            let dayOfWeekSV: UIStackView = getDayOfTheWeekStackViewFrom(dayOfTheWeek: lastWeekDayPopulated % 7)
            dayOfWeekSV.addArrangedSubview(makeDateButtonWith(day: date, month: prevMonth, year: prevMonthYear, isInCurrentMonth: false, dayOfTheWeek: lastWeekDayPopulated, isEnabled: true, isVisible: true))
            lastWeekDayPopulated = increment(dayOfTheWeek: lastWeekDayPopulated)
        }
        
        for n in 1...getNumberOfDaysIn(month: month, year: year) {
            let dayOfWeekSV: UIStackView = getDayOfTheWeekStackViewFrom(dayOfTheWeek: lastWeekDayPopulated % 7)
            dayOfWeekSV.addArrangedSubview(makeDateButtonWith(day: n, month: month, year: year, isInCurrentMonth: true, dayOfTheWeek: lastWeekDayPopulated, isEnabled: true, isVisible: true))
            lastWeekDayPopulated = increment(dayOfTheWeek: lastWeekDayPopulated)
        }
        
        var nextDate: Int = 1
        
        for _ in lastWeekDayPopulated...7 { //Populate days visible on calendar after the current month.
            let dayOfWeekSV: UIStackView = getDayOfTheWeekStackViewFrom(dayOfTheWeek: lastWeekDayPopulated % 7)
            dayOfWeekSV.addArrangedSubview(makeDateButtonWith(day: nextDate, month: nextMonth, year: nextMonthYear, isInCurrentMonth: false, dayOfTheWeek: lastWeekDayPopulated, isEnabled: true, isVisible: true))
            nextDate += 1
            lastWeekDayPopulated = increment(dayOfTheWeek: lastWeekDayPopulated)
        }
        
        return [sundaySV!, mondaySV!, tuesdaySV!, wednesdaySV!, thursdaySV!, fridaySV!, saturdaySV!]
    }
    
    private func getNumberOfDaysIn(month: Int, year: Int?) -> Int {
        if (month == 2) {
            //TODO: Account for leap years
            //        if (month == 2 && ((year % 4 == 0 && year % 100 == 0) || year % 400 == 0)) {
            //
            //        }
        }
        return numDays[month - 1]
    }
    
    private func applyStyling() {
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
    
    private func setButtonApperance(index: Int) {
        var buttonMetaData = dateButtonMetadata[index]
        var dateBtn = dateButtons[index]
        let isInCurrentMonth = buttonMetaData.month == currentMonth
        dateBtn.isEnabled = self.button(isEnabled: isEnabled, dayOfTheWeek: buttonMetaData.dayOfTheWeek, isInCurrentMonth: isInCurrentMonth)
        if (dateBtn.isEnabled) {
            dateBtn.titleLabel?.font = self.cellFont
        } else {
            dateBtn.titleLabel?.font = self.cellFontForDaysNotInCurrentMonth
        }
        if (isInCurrentMonth) {
            dateBtn.backgroundColor = (dateBtn.isEnabled) ? self.cellBackgroundColor : self.cellBackgroundColorDisabled
        } else {
            dateBtn.backgroundColor = self.cellBackgroundColorForDaysNotInCurrentMonth
        }
        dateBtn.setTitleColor(self.cellColor, for: .normal)
        dateBtn.setTitleColor(self.cellColorDisabled, for: .disabled)
        if (self.showCellSeperators) {
            dateBtn.layer.borderColor = self.borderColor.cgColor
            dateBtn.layer.borderWidth = 1.0
        } else {
            dateBtn.layer.borderColor = UIColor.clear.cgColor
            dateBtn.layer.borderWidth = 0.0
        }
    }
    
    private func makeDateButtonWith(day: Int, month: Int, year: Int, isInCurrentMonth: Bool, dayOfTheWeek: Int, isEnabled: Bool, isVisible: Bool) -> UIButton {
        let dateBtn: UIButton = UIButton()
        dateBtn.setTitle("\(day)", for: (isEnabled == true) ? .normal : .disabled)
        
        dateBtn.tag = self.dateButtonMetadata.count
        let buttonMetaData = DateButtonMetadata(date: self.dateFormatter.date(from: "\(year)-\(month)-\(day)")!, index: dateBtn.tag, dayOfTheWeek: dayOfTheWeek, month: month, year: year, day: day)
        self.dateButtonMetadata.append(buttonMetaData)
        self.dateButtons.append(dateBtn)
        dateBtn.addTarget(self, action: #selector(onBtnTapped), for: .touchUpInside)
        dateBtn.translatesAutoresizingMaskIntoConstraints = true
        dateBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        dateBtn.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        dateBtn.layer.masksToBounds = true
        setButtonApperance(index: dateBtn.tag)
        return dateBtn
    }
    
    private func getIndexRangeForDaysInCurrentMonth() -> ClosedRange<Int> {
        return weekDayOfTheFirst...getNumberOfDaysIn(month: currentMonth, year: currentYear) + weekDayOfTheFirst
    }
    
    private func getIndexesForDaysNotInCurrentMonth() -> [Int] {
        var indexes: [Int] = []
        let currentMonthRange: ClosedRange<Int> = getIndexRangeForDaysInCurrentMonth()
        for i in 0...dateButtons.count {
            if (currentMonthRange.contains(i) == false) {
                indexes.append(i)
            }
        }
        return indexes
    }
    
    private func button(isEnabled: Bool, dayOfTheWeek: Int?, isInCurrentMonth: Bool) -> Bool
    {
        switch(dayOfTheWeek){
        case 1:
            return self.enableSundays && isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        case 2:
            return self.enableMondays && isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        case 3:
            return self.enableTuesdays && isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        case 4:
            return self.enableWednesdays && isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        case 5:
            return self.enableThursdays && isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        case 6:
            return self.enableFridays && isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        case 7:
            return self.enableSaturdays && isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        default:
            return isEnabled && (isInCurrentMonth || self.enableDaysNotInCurrentMonth)
        }
    }
//    private func changeSateEnabledStateBy(dayOfTheWeek: Int, isEnabled: Bool) {
//        let numberOfDaysInMonth = numDays[month]
//        var currentDayOfTheWeek = weekDayOfTheFirst
//        for i in weekDayOfTheFirst...numberOfDaysInMonth + weekDayOfTheFirst {
//            if(currentDayOfTheWeek == dayOfTheWeek) {
//                dateButtons[i-1].isEnabled = isEnabled
//            }
//            currentDayOfTheWeek = incrementDayOfTheWeek(dayOfTheWeek: currentDayOfTheWeek)
//        }
//    }
    
    private func getDayOfTheWeekStackViewFrom(dayOfTheWeek: Int) -> UIStackView {
        switch (dayOfTheWeek % 7) {
        case 1: //Sunday
            return sundaySV!
        case 2: //Monday
            return mondaySV!
        case 3: //Tuesday
            return tuesdaySV!
        case 4: //Wednesday
            return wednesdaySV!
        case 5: //Thursday
            return thursdaySV!
        case 6: //Friday
            return fridaySV!
        default: // Saturday
            return saturdaySV!
        }
    }
    
    private func increment(dayOfTheWeek: Int) -> Int {
        var nextDayOfTheWeek: Int = dayOfTheWeek + 1
        if (nextDayOfTheWeek > 7) {
            nextDayOfTheWeek = 1
        }
        return nextDayOfTheWeek
    }
    
    @objc private func onBtnTapped(sender: UIButton) {
//        print(dates[sender.tag])
        selectedDate = dateButtonMetadata[sender.tag].date
        self.sendActions(for: .valueChanged)
    }
    
    func set(date: Date) {
        self.selectedDate = date
        dateFormatter.dateFormat = "yyyy-M-d"
        let calendar = Calendar.current
        currentMonth = calendar.component(.month, from: date)
        currentYear = calendar.component(.year, from: date)
        let dateOfTheFirst: Date = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-1")!
        self.date = dateOfTheFirst
        weekDayOfTheFirst = Calendar.current.component(.weekday, from: dateOfTheFirst)
        updateView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set(date: Date())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        set(date: Date())
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    private class DateButtonMetadata {
        var date: Date
        var index: Int
        var dayOfTheWeek: Int
        var month: Int
        var year: Int
        var day: Int
        
        init(date: Date, index: Int, dayOfTheWeek: Int, month: Int, year: Int, day: Int) {
            self.date = date
            self.index = index
            self.dayOfTheWeek = dayOfTheWeek
            self.month = month
            self.year = year
            self.day = day
            
        }
    }

}
