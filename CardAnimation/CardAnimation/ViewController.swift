//
//  ViewController.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/21/20.
//

import UIKit

class ViewController: UIViewController {
    let year: Int
    let month: Int

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expirationDatePicker: CurrentDatePickerView!
    
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
        
        expirationDatePicker.newDelegate = self
        
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

extension ViewController: CurrentDatePickerViewDelegate {
    func selectionChanged(_ newDate: Date) {
        cardView.update(expirationDate: newDate)
    }
}
