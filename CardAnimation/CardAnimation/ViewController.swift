//
//  ViewController.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/21/20.
//

import UIKit

class ViewController: UIViewController {
    var cardView: CardView!
    let year: Int
    let month: Int

    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expirationDatePicker: UIPickerView!
    
    required init?(coder: NSCoder) {
        let now = Date()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        year = Int(df.string(from: now))!
        
        df.dateFormat = "M"
        month = Int(df.string(from: now))!
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        expirationDatePicker.dataSource = self
        expirationDatePicker.delegate = self
        
        expirationDatePicker.selectRow(month - 1, inComponent: 0, animated: false)
        expirationDatePicker.selectRow(500, inComponent: 1, animated: false)
        
        cardNumberTextField.delegate = self
        cardHolderNameTextField.delegate = self
        cvvTextField.delegate = self
        
        cardNumberTextField.addTarget(self, action: #selector(cardNumberChanged(_:)), for: .editingChanged)
        cardHolderNameTextField.addTarget(self, action: #selector(cardHolderChanged(_:)), for: .editingChanged)
        cvvTextField.addTarget(self, action: #selector(cvvChanged(_:)), for: .editingChanged)
        
        cardNumberTextField.backgroundColor = .lightGray
        cardHolderNameTextField.backgroundColor = .lightGray
        cvvTextField.backgroundColor = .lightGray
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if cardView == nil {
            cardView = CardView(origin: CGPoint(x: 16, y: view.safeAreaInsets.top + 16), width: view.bounds.width - 32)
            view.addSubview(cardView)
        }
    }
    
    @objc
    private func cardNumberChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        cardView.update(cardNumber: text)
    }
    
    @objc
    private func cardHolderChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        cardView.update(nameOnCard: text)
    }
    
    @objc
    private func cvvChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        cardView.update(cvv: text)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cvvTextField {
            cardView.flipCard()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == cvvTextField {
            cardView.flipCard()
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        
        cardView.update(expirationDate: Calendar.current.date(from: dateComponents)!)
    }
}

