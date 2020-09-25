//
//  CustomDatePicker.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/23/20.
//

import UIKit

protocol CurrentDatePickerViewDelegate: AnyObject {
    func selectionChanged(_ newDate: Date)
}

class CurrentDatePickerView: UIPickerView {
    let year: Int
    let month: Int
    
    weak var newDelegate: CurrentDatePickerViewDelegate?
    
    override init(frame: CGRect) {
        let date = Self.getDate()
        year = date.year
        month = date.month
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        let date = Self.getDate()
        year = date.year
        month = date.month
        
        super.init(coder: coder)
        
        setup()
    }
    
    private static func getDate() -> (month: Int, year: Int) {
        let now = Date()
        let df = DateFormatter()
        
        df.dateFormat = "yyyy"
        let year = Int(df.string(from: now))!
        
        df.dateFormat = "M"
        let month = Int(df.string(from: now))!
        
        return (month, year)
    }
    
    private func setup() {
        delegate = self
        dataSource = self
    }
}

extension CurrentDatePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 12
        } else {
            return 1000
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        38
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = component == 0 ? Month(rawValue: row).string : String(year - 500 + row)
        
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dateComponents = DateComponents()
        dateComponents.month = pickerView.selectedRow(inComponent: 0) + 1
        dateComponents.year = year + pickerView.selectedRow(inComponent: 1) - 500
        
        if let newDate = Calendar.current.date(from: dateComponents) {
            newDelegate?.selectionChanged(newDate)
        }
    }
}
