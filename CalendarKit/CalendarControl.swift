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
    
    private static let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private static let weekDays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"]
    private static let numDays: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    private var buttonsMap: [String : MonthCalendar] = [:]
    
    private static let dateFormatter = DateFormatter()
    
    private var currentCalendar: MonthCalendar? = nil
    
    private var date: Date = Date()
    
    private var disabledDates: [Date] = []
    
    var selectedDate: Date? = nil
    
    @IBInspectable
    var headerBackgroundColor: UIColor = UIColor.white {
        didSet {
            currentCalendar?.monthLabel?.backgroundColor = headerBackgroundColor
        }
    }
    
    @IBInspectable
    var headerColor: UIColor = UIColor.black {
        didSet {
            currentCalendar?.monthLabel?.textColor = headerColor
        }
    }
    
    @IBInspectable
    var headerFont: UIFont = UIFont.boldSystemFont(ofSize: 20.0) {
        didSet{
            currentCalendar?.monthLabel?.font = headerFont
        }
    }
    
    @IBInspectable
    var cellBackgroundColor: UIColor = UIColor.white {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var cellColor: UIColor = UIColor.darkGray {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var cellFont: UIFont = UIFont.boldSystemFont(ofSize: 20.0) {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var cellColorDisabled: UIColor = UIColor.lightGray {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var cellBackgroundColorDisabled: UIColor = UIColor.white {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var cellBackgroundColorForDaysNotInCurrentMonth: UIColor? = nil {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var cellFontForDaysNotInCurrentMonth: UIFont = UIFont.systemFont(ofSize: 20.0) {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var cellIsVisbleForDaysNotInCurrentMonth: Bool = false {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.black {
        didSet {
            
            updateStyling()
        }
    }
    
    @IBInspectable
    var showCellSeperators: Bool = false {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableSundays: Bool = true {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableMondays: Bool = true {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableTuesdays: Bool = true {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableWednesdays: Bool = true {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableThursdays: Bool = true {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableFridays: Bool = true {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableSaturdays: Bool = true {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var disableDatesInPast: Bool = false {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var enableDaysNotInCurrentMonth: Bool = false {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var selectionColor: UIColor? = nil {
        didSet {
            updateStyling()
        }
    }
    
    @IBInspectable
    var selectionTextColor: UIColor? = nil {
        didSet {
            updateStyling()
        }
    }
    
    var selectionStyle: SelectionStyle = .Circle {
        didSet {
            updateStyling()
        }
    }
    
    enum SelectionStyle {
        case Underline
        case BigBorder
        case Circle
        case Background
        case None
    }
    
    private func applyStyling() {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2.0
        self.accessibilityIdentifier = "CalendarControl"
        self.translatesAutoresizingMaskIntoConstraints = true
        
        currentCalendar!.monthLabel!.layer.borderColor = borderColor.cgColor
        currentCalendar!.monthLabel!.layer.borderWidth = 1.0
        currentCalendar!.monthLabel!.textAlignment = .center
        currentCalendar!.monthLabel!.textColor = headerColor
        currentCalendar!.monthLabel!.font = headerFont
        currentCalendar!.monthLabel!.backgroundColor = headerBackgroundColor
        currentCalendar!.monthLabel!.accessibilityIdentifier = "monthLabel"
        currentCalendar!.monthLabel!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.monthLabel!.centerXAnchor.constraint(equalTo: currentCalendar!.calendarSV!.centerXAnchor).isActive = true
        currentCalendar!.monthLabel!.topAnchor.constraint(equalTo: currentCalendar!.calendarSV!.topAnchor).isActive = true
        currentCalendar!.monthLabel!.widthAnchor.constraint(equalTo: currentCalendar!.calendarSV!.widthAnchor, multiplier: 1).isActive = true
        currentCalendar!.monthLabel!.heightAnchor.constraint(equalTo: currentCalendar!.calendarSV!.heightAnchor, multiplier: 0.125).isActive = true
        
        currentCalendar!.weeksSV!.accessibilityIdentifier = "weeksSV"
        currentCalendar!.weeksSV!.axis = .horizontal
        currentCalendar!.weeksSV!.distribution = .fillEqually
        currentCalendar!.weeksSV!.alignment = .center
        currentCalendar!.weeksSV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.weeksSV!.bottomAnchor.constraint(equalTo: currentCalendar!.calendarSV!.bottomAnchor).isActive = true
        currentCalendar!.weeksSV!.leftAnchor.constraint(equalTo: currentCalendar!.calendarSV!.leftAnchor).isActive = true
        currentCalendar!.weeksSV!.rightAnchor.constraint(equalTo: currentCalendar!.calendarSV!.rightAnchor).isActive = true
        currentCalendar!.weeksSV!.topAnchor.constraint(equalTo: currentCalendar!.monthLabel!.bottomAnchor).isActive = true
        
        currentCalendar!.sundaySV!.accessibilityIdentifier = "sundaySV"
        currentCalendar!.sundaySV!.axis = .vertical
        currentCalendar!.sundaySV!.distribution = .fillEqually
        currentCalendar!.sundaySV!.alignment = .fill
        currentCalendar!.sundaySV!.spacing = 0
        currentCalendar!.sundaySV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.sundaySV!.topAnchor.constraint(equalTo: currentCalendar!.weeksSV!.topAnchor).isActive = true
        currentCalendar!.sundaySV!.bottomAnchor.constraint(equalTo: currentCalendar!.weeksSV!.bottomAnchor).isActive = true

        currentCalendar!.mondaySV!.accessibilityIdentifier = "mondaySV"
        currentCalendar!.mondaySV!.axis = .vertical
        currentCalendar!.mondaySV!.distribution = .fillEqually
        currentCalendar!.mondaySV!.alignment = .fill
        currentCalendar!.mondaySV!.spacing = 0
        currentCalendar!.mondaySV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.mondaySV!.topAnchor.constraint(equalTo: currentCalendar!.weeksSV!.topAnchor).isActive = true
        currentCalendar!.mondaySV!.bottomAnchor.constraint(equalTo: currentCalendar!.weeksSV!.bottomAnchor).isActive = true

        currentCalendar!.tuesdaySV!.accessibilityIdentifier = "tuesdaySV"
        currentCalendar!.tuesdaySV!.axis = .vertical
        currentCalendar!.tuesdaySV!.distribution = .fillEqually
        currentCalendar!.tuesdaySV!.alignment = .fill
        currentCalendar!.tuesdaySV!.spacing = 0
        currentCalendar!.tuesdaySV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.tuesdaySV!.topAnchor.constraint(equalTo: currentCalendar!.weeksSV!.topAnchor).isActive = true
        currentCalendar!.tuesdaySV!.bottomAnchor.constraint(equalTo: currentCalendar!.weeksSV!.bottomAnchor).isActive = true

        currentCalendar!.wednesdaySV!.accessibilityIdentifier = "wednesdaySV"
        currentCalendar!.wednesdaySV!.axis = .vertical
        currentCalendar!.wednesdaySV!.distribution = .fillEqually
        currentCalendar!.wednesdaySV!.alignment = .fill
        currentCalendar!.wednesdaySV!.spacing = 0
        currentCalendar!.wednesdaySV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.wednesdaySV!.topAnchor.constraint(equalTo: currentCalendar!.weeksSV!.topAnchor).isActive = true
        currentCalendar!.wednesdaySV!.bottomAnchor.constraint(equalTo: currentCalendar!.weeksSV!.bottomAnchor).isActive = true

        currentCalendar!.thursdaySV!.accessibilityIdentifier = "thursdaySV"
        currentCalendar!.thursdaySV!.axis = .vertical
        currentCalendar!.thursdaySV!.distribution = .fillEqually
        currentCalendar!.thursdaySV!.alignment = .fill
        currentCalendar!.thursdaySV!.spacing = 0
        currentCalendar!.thursdaySV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.thursdaySV!.topAnchor.constraint(equalTo: currentCalendar!.weeksSV!.topAnchor).isActive = true
        currentCalendar!.thursdaySV!.bottomAnchor.constraint(equalTo: currentCalendar!.weeksSV!.bottomAnchor).isActive = true

        currentCalendar!.fridaySV!.accessibilityIdentifier = "fridaySV"
        currentCalendar!.fridaySV!.axis = .vertical
        currentCalendar!.fridaySV!.distribution = .fillEqually
        currentCalendar!.fridaySV!.alignment = .fill
        currentCalendar!.fridaySV!.spacing = 0
        currentCalendar!.fridaySV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.fridaySV!.topAnchor.constraint(equalTo: currentCalendar!.weeksSV!.topAnchor).isActive = true
        currentCalendar!.fridaySV!.bottomAnchor.constraint(equalTo: currentCalendar!.weeksSV!.bottomAnchor).isActive = true

        currentCalendar!.saturdaySV!.accessibilityIdentifier = "saturdaySV"
        currentCalendar!.saturdaySV!.axis = .vertical
        currentCalendar!.saturdaySV!.distribution = .fillEqually
        currentCalendar!.saturdaySV!.alignment = .fill
        currentCalendar!.saturdaySV!.spacing = 0
        currentCalendar!.saturdaySV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.saturdaySV!.topAnchor.constraint(equalTo: currentCalendar!.weeksSV!.topAnchor).isActive = true
        currentCalendar!.saturdaySV!.bottomAnchor.constraint(equalTo: currentCalendar!.weeksSV!.bottomAnchor).isActive = true
        
        currentCalendar!.calendarSV!.layer.borderColor = borderColor.cgColor
        currentCalendar!.calendarSV!.layer.borderWidth = 1.0
        currentCalendar!.calendarSV!.accessibilityIdentifier = "calendarSV"
        currentCalendar!.calendarSV!.axis = .vertical
        currentCalendar!.calendarSV!.translatesAutoresizingMaskIntoConstraints = false
        currentCalendar!.calendarSV!.backgroundColor = UIColor.blue
        currentCalendar!.calendarSV!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        currentCalendar!.calendarSV!.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        currentCalendar!.calendarSV!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        currentCalendar!.calendarSV!.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    private func setButtonApperance(index: Int) {
        let buttonMetaData: DateButtonMetadata = currentCalendar!.dateButtonMetadata[index]
        let dateBtn: UIButton = currentCalendar!.dateButtons[index]
        let isInCurrentMonth: Bool = currentCalendar!.dateButtonMetadata[index].month == currentCalendar!.month
        let isSelectedDate: Bool = Calendar.current.compare((self.currentCalendar?.dateButtonMetadata[index].date)!, to: self.selectedDate!, toGranularity: .day)  == .orderedSame
        dateBtn.isEnabled = self.button(isEnabled: isEnabled, dayOfTheWeek: buttonMetaData.dayOfTheWeek, isInCurrentMonth: isInCurrentMonth, btnData: buttonMetaData)
        if (dateBtn.isEnabled) {
            dateBtn.titleLabel?.font = self.cellFont
        } else {
            dateBtn.titleLabel?.font = self.cellFontForDaysNotInCurrentMonth
        }
        if (isInCurrentMonth) {
            dateBtn.backgroundColor = (dateBtn.isEnabled) ? self.cellBackgroundColor : self.cellBackgroundColorDisabled
        } else {//if (self.enableDaysNotInCurrentMonth) {
            dateBtn.backgroundColor = (dateBtn.isEnabled) ? self.cellBackgroundColorForDaysNotInCurrentMonth ?? self.cellBackgroundColor : self.cellBackgroundColorDisabled
        }
        dateBtn.setTitleColor(self.cellColor, for: .normal)
        dateBtn.setTitleColor(self.cellColorDisabled, for: .disabled)
        if (isInCurrentMonth == false && self.cellIsVisbleForDaysNotInCurrentMonth == false && self.enableDaysNotInCurrentMonth == false) {
            dateBtn.setTitleColor(UIColor.clear, for: .disabled)
            dateBtn.backgroundColor = self.cellBackgroundColor
        }
        if (self.showCellSeperators) {
            dateBtn.layer.borderColor = self.borderColor.cgColor
            dateBtn.layer.borderWidth = 1.0
        } else {
            dateBtn.layer.borderColor = UIColor.clear.cgColor
            dateBtn.layer.borderWidth = 0.0
        }
        if (isSelectedDate && dateBtn.isEnabled) {
            switch(self.selectionStyle) {
                case .Underline:
                    self.removeAnySelectionStyling(btn: dateBtn)
                    self.setUnderlineSelectionStyling(btn: dateBtn)
                case .BigBorder:
                    self.removeAnySelectionStyling(btn: dateBtn)
                    self.setBigBorderSelectionStyleing(btn: dateBtn)
                case .Circle:
                    self.removeAnySelectionStyling(btn: dateBtn)
                    self.setCircleSelectionStyling(btn: dateBtn)
                case .Background:
                    self.removeAnySelectionStyling(btn: dateBtn)
                    self.setBackgroundSelectionStyling(btn: dateBtn)
                case .None:
                    self.removeAnySelectionStyling(btn: dateBtn)
            }
        } else {
            self.removeAnySelectionStyling(btn: dateBtn)
        }
    }
    
    private func setUnderlineSelectionStyling(btn: UIButton) {
        let normalAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor : self.selectionTextColor ?? btn.titleColor(for: .normal)!
            ])
        let disabledAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor : self.selectionTextColor ?? btn.titleColor(for: .disabled)!
            ])
        btn.setAttributedTitle(normalAttributedTitle, for: .normal)
        btn.setAttributedTitle(disabledAttributedTitle, for: .disabled)
    }
    
    private func setBigBorderSelectionStyleing(btn: UIButton) {
        btn.layer.borderColor = self.selectionColor?.cgColor ?? self.borderColor.cgColor
        btn.layer.borderWidth = 4.0
    }
    
    private func setCircleSelectionStyling(btn: UIButton) {
        let normalAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
            NSAttributedString.Key.foregroundColor : self.selectionTextColor ?? btn.titleColor(for: .normal)!
            ])
        let disabledAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
            NSAttributedString.Key.foregroundColor : self.selectionTextColor ?? btn.titleColor(for: .disabled)!
            ])
        btn.setAttributedTitle(normalAttributedTitle, for: .normal)
        btn.setAttributedTitle(disabledAttributedTitle, for: .disabled)
        btn.titleLabel!.layer.cornerRadius = btn.titleLabel!.frame.width / 2
        btn.titleLabel!.clipsToBounds = true
        btn.titleLabel!.backgroundColor = self.selectionColor ?? ((btn.isEnabled) ? self.cellBackgroundColor : self.cellBackgroundColorDisabled)
    }
    
    private func setBackgroundSelectionStyling(btn: UIButton) {
        let normalAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
            NSAttributedString.Key.foregroundColor : self.selectionTextColor ?? btn.titleColor(for: .normal)!
            ])
        let disabledAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
            NSAttributedString.Key.foregroundColor : self.selectionTextColor ?? btn.titleColor(for: .disabled)!
            ])
        btn.setAttributedTitle(normalAttributedTitle, for: .normal)
        btn.setAttributedTitle(disabledAttributedTitle, for: .disabled)
        btn.titleLabel!.clipsToBounds = true
        btn.backgroundColor = self.selectionColor ?? ((btn.isEnabled) ? self.cellBackgroundColor : self.cellBackgroundColorDisabled)
        btn.titleLabel!.backgroundColor = self.selectionColor ?? ((btn.isEnabled) ? self.cellBackgroundColor : self.cellBackgroundColorDisabled)
    }
    
    private func removeAnySelectionStyling(btn: UIButton) {
        let normalAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
            NSAttributedString.Key.foregroundColor : btn.titleColor(for: .normal)!
            ])
        let disabledAttributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: btn.titleLabel!.text!, attributes: [
            NSAttributedString.Key.foregroundColor : btn.titleColor(for: .disabled)!
            ])
        btn.setAttributedTitle(normalAttributedTitle, for: .normal)
        btn.setAttributedTitle(disabledAttributedTitle, for: .disabled)
        btn.titleLabel!.layer.cornerRadius = 0
        btn.titleLabel!.clipsToBounds = true
        btn.titleLabel!.backgroundColor = (btn.isEnabled) ? self.cellBackgroundColor : self.cellBackgroundColorDisabled
    }
    
    public func add(disabledDate: Date) {
        let formattedDateString: String = UICalendar.dateFormatter.string(from: disabledDate)
        let formattedDate: Date = UICalendar.dateFormatter.date(from: formattedDateString)!
        let existingIndex: Int? = self.disabledDates.firstIndex(of: formattedDate)
        if (existingIndex == nil) {
            self.disabledDates.append(formattedDate)
            self.disabledDates.sort()
            self.updateStyling()
        }
    }
    
    public func remove(disabledDate: Date) {
        let formattedDateString: String = UICalendar.dateFormatter.string(from: disabledDate)
        let formattedDate: Date = UICalendar.dateFormatter.date(from: formattedDateString)!
        let indexToRemove: Int? = self.disabledDates.firstIndex(of: formattedDate)
        if (indexToRemove != nil) {
            self.disabledDates.remove(at: indexToRemove!)
            self.updateStyling()
        }
    }
    
    private func button(isEnabled: Bool, dayOfTheWeek: Int?, isInCurrentMonth: Bool, btnData: DateButtonMetadata) -> Bool
    {
        let isInCurrentMonthEnabled = isInCurrentMonth || (self.enableDaysNotInCurrentMonth)
        var isBtnEnabled: Bool = false
        switch(dayOfTheWeek){
        case 1:
            isBtnEnabled = self.enableSundays && isEnabled && isInCurrentMonthEnabled
        case 2:
            isBtnEnabled = self.enableMondays && isEnabled && isInCurrentMonthEnabled
        case 3:
            isBtnEnabled = self.enableTuesdays && isEnabled && isInCurrentMonthEnabled
        case 4:
            isBtnEnabled = self.enableWednesdays && isEnabled && isInCurrentMonthEnabled
        case 5:
            isBtnEnabled = self.enableThursdays && isEnabled && isInCurrentMonthEnabled
        case 6:
            isBtnEnabled = self.enableFridays && isEnabled && isInCurrentMonthEnabled
        case 7:
            isBtnEnabled = self.enableSaturdays && isEnabled && isInCurrentMonthEnabled
        default:
            isBtnEnabled = isEnabled && isInCurrentMonthEnabled
        }
        if (isBtnEnabled == true) {
            if (self.disableDatesInPast == true) {
                let today: Date = Date()
                let isPast: Bool = Calendar.current.compare(today, to: btnData.date, toGranularity: .day) != .orderedDescending
                isBtnEnabled = isPast
            }
            if (isBtnEnabled == true) {
                isBtnEnabled = !self.disabledDates.contains(btnData.date)
            }
        }
        return isBtnEnabled
    }
    
    @objc private func onBtnTapped(sender: UIButton) {
        self.set(selectedDate: currentCalendar!.dateButtonMetadata[sender.tag].date)
        self.sendActions(for: .valueChanged)
    }
    
    override func didAddSubview(_ subview: UIView) {
        updateStyling()
    }
    
    func set(date: Date) {
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        let dateOfTheFirst: Date = UICalendar.dateFormatter.date(from: "\(year)-\(month)-1")!
        if (currentCalendar != nil) {
            currentCalendar!.calendarSV!.removeFromSuperview()
            for btn in currentCalendar!.dateButtons {
                unregisterButtonEvents(button: btn)
            }
        }
        currentCalendar = getCalendarBy(dateOfTheFirst: dateOfTheFirst)
        for btn in currentCalendar!.dateButtons {
            registerButtonEvents(button: btn)
        }
        self.date = dateOfTheFirst
        self.addSubview((currentCalendar?.calendarSV)!)
        self.didAddSubview((currentCalendar?.calendarSV)!)
    }
    
    func set(selectedDate: Date){
        self.selectedDate = selectedDate
        updateStyling()
    }
    
    private func unregisterButtonEvents(button: UIButton) {
        button.removeTarget(self, action: nil, for: .allEvents)
    }
    
    private func registerButtonEvents(button: UIButton) {
        button.addTarget(self, action: #selector(onBtnTapped), for: .touchUpInside)
    }
    
    private func updateStyling() {
        if (currentCalendar != nil){
            applyStyling()
            for i in 0...currentCalendar!.dateButtons.count-1 {
                setButtonApperance(index: i)
            }
        }
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    func changeDateBy(numberOfMonths: Int) {
        if (currentCalendar != nil) {
            let date = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self.date)!
            set(date: date)
        }
    }
    
    func changeDateBy(numberOfYears: Int) {
        if (currentCalendar != nil) {
            let date = Calendar.current.date(byAdding: .year, value: numberOfYears, to: self.date)!
            set(date: date)
        }
    }
    
    private func getCalendarBy(dateOfTheFirst: Date) -> MonthCalendar {
        let key = UICalendar.dateFormatter.string(from: dateOfTheFirst)
        var calendar: MonthCalendar? = buttonsMap[key]
        if (calendar == nil) {
            calendar = MonthCalendar(date: dateOfTheFirst)
        }
        return calendar!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UICalendar.dateFormatter.dateFormat = "yyyy-M-d"
        self.set(selectedDate: Date())
        self.set(date: self.selectedDate!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UICalendar.dateFormatter.dateFormat = "yyyy-M-d"
        self.set(selectedDate: Date())
        self.set(date: self.selectedDate!)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    private class MonthCalendar {
        
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
        
        var dateButtons: [UIButton] = []
        
        var dateButtonMetadata: [DateButtonMetadata] = []
        
        var weekDayOfTheFirst: Int = 0
        var month: Int = 0
        var year: Int = 0
        
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
        
        private func buildMonthDateStackViews(month: Int, year: Int) -> [UIStackView] {
            
            let prevMonth: Int = (month == 1) ? 12 : month - 1
            let prevMonthYear: Int = (prevMonth == 12) ? year - 1 : year
            let prevMonthNumDays: Int = getNumberOfDaysIn(month: prevMonth, year: prevMonthYear)
            
            let nextMonth: Int = (month == 12) ? 1 : month + 1
            let nextMonthYear: Int = (month == 1) ? year + 1 : year
            
            var lastWeekDayPopulated: Int = 1;
            if (weekDayOfTheFirst > 1){
                for n in 1...weekDayOfTheFirst - 1 {//Populate buttons on calendar that are from the previous month.
                    let date: Int = prevMonthNumDays - weekDayOfTheFirst + n + 1
                    let dayOfWeekSV: UIStackView = getDayOfTheWeekStackViewFrom(dayOfTheWeek: lastWeekDayPopulated % 7)
                    dayOfWeekSV.addArrangedSubview(makeDateButtonWith(day: date, month: prevMonth, year: prevMonthYear, isInCurrentMonth: false, dayOfTheWeek: lastWeekDayPopulated, isEnabled: true, isVisible: true))
                    lastWeekDayPopulated = increment(dayOfTheWeek: lastWeekDayPopulated)
                }
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
            return UICalendar.numDays[month - 1]
        }
        
        private func createView() {
            dateButtons = []
            dateButtonMetadata = []
            calendarSV = UIStackView()
            
            monthLabel = UILabel()
            monthLabel!.text = "\(UICalendar.months[month-1]) \(year)"
            
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
        }
        
        private func makeDateButtonWith(day: Int, month: Int, year: Int, isInCurrentMonth: Bool, dayOfTheWeek: Int, isEnabled: Bool, isVisible: Bool) -> UIButton {
            let dateBtn: UIButton = UIButton()
            dateBtn.setTitle("\(day)", for: (isEnabled == true) ? .normal : .disabled)
            
            dateBtn.tag = dateButtonMetadata.count
            let buttonMetaData = DateButtonMetadata(date: UICalendar.dateFormatter.date(from: "\(year)-\(month)-\(day)")!, index: dateBtn.tag, dayOfTheWeek: dayOfTheWeek, month: month, year: year, day: day)
            dateButtonMetadata.append(buttonMetaData)
            dateButtons.append(dateBtn)
//            dateBtn.translatesAutoresizingMaskIntoConstraints = true
            dateBtn.titleLabel?.adjustsFontSizeToFitWidth = false
//            dateBtn.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            dateBtn.layer.masksToBounds = true
            dateBtn.titleLabel?.addConstraint(NSLayoutConstraint(item: dateBtn.titleLabel!, attribute: .height, relatedBy: .equal, toItem: dateBtn.titleLabel!, attribute: .width, multiplier: 1, constant: 0))
            dateBtn.titleLabel?.textAlignment = .center
            return dateBtn
        }
        
        private func getIndexRangeForDaysInCurrentMonth() -> ClosedRange<Int> {
            return weekDayOfTheFirst...getNumberOfDaysIn(month: month, year: year) + weekDayOfTheFirst
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
        
        private func increment(dayOfTheWeek: Int) -> Int {
            var nextDayOfTheWeek: Int = dayOfTheWeek + 1
            if (nextDayOfTheWeek > 7) {
                nextDayOfTheWeek = 1
            }
            return nextDayOfTheWeek
        }
        
        init(date: Date) {
            month = Calendar.current.component(.month, from: date)
            year = Calendar.current.component(.year, from: date)
            weekDayOfTheFirst = Calendar.current.component(.weekday, from: date)
            createView()
        }
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
