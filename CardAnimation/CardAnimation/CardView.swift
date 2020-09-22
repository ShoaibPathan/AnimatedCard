//
//  CardView.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/21/20.
//

import UIKit

// MARK: - CardView

class CardView: UIView {
    
    // MARK: - CardView: Variables
    
    var cardProvider: CardProvider = .none {
        didSet {
            updateCard()
        }
    }
    var monoFont: UIFont? {
        didSet {
            guard let font = monoFont else { return }
            front.font = font
            back.font = font
        }
    }
    
    private var isFlipped = false
    private var duration: Double = 0.5
    
    private var front: FrontCardView
    private var back: BackCardView
    
    // MARK: - CardView: Initializers
    
    init(origin: CGPoint, height: CGFloat) {
        let frame = CGRect(origin: origin, size: CGSize(width: 1.586 * height, height: height))
        let bounds = CGRect(origin: .zero, size: frame.size)
        
        front = FrontCardView(frame: bounds)
        back = BackCardView(frame: bounds)
        
        super.init(frame: frame)
        
        setup()
    }
    
    init(origin: CGPoint, width: CGFloat) {
        let frame = CGRect(origin: origin, size: CGSize(width: width, height: width / 1.586))
        let bounds = CGRect(origin: .zero, size: frame.size)
        
        front = FrontCardView(frame: bounds)
        back = BackCardView(frame: bounds)
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        guard let tempFront = FrontCardView(coder: coder),
              let tempBack = BackCardView(coder: coder) else { return nil }
        
        front = tempFront
        back = tempBack

        super.init(coder: coder)

        setup()
    }
    
    // MARK: - CardView: Private Functions
    
    private func setup() {
        update()
        
        updateCard()
        
        monoFont = .monospacedSystemFont(ofSize: frame.width / 19, weight: .black)
        
        addSubview(front)
        addSubview(back)
        
        let viewToHide = isFlipped ? front : back
        viewToHide.isHidden = true
    }
    
    private func updateCard() {
        front.backgroundColor = cardProvider.color
        back.backgroundColor = cardProvider.color
        front.setImage(cardProvider.image)
        
    }
    
    // MARK: - CardView: Public Functions
    
    // Animate card flipping sides
    func flipCard() {
        isFlipped.toggle()
        
        
        // Select start and end views and flip direction
        let from: UIView
        let to: UIView
        let flipDirection: AnimationOptions
        
        if isFlipped {
            from = front
            to = back
            flipDirection = .transitionFlipFromRight
        } else {
            from = back
            to = front
            flipDirection = .transitionFlipFromLeft
        }
        
        // Animate
        UIView.transition(from: from, to: to, duration: duration, options: [flipDirection, .showHideTransitionViews], completion: nil)
    }
    
    // Update card information
    func update(cardNumber: String = "", expirationDate: Date = .default, nameOnCard: String = "", cvv: String = "") {
        if cardNumber.count > 0, let val = Int(String(cardNumber[cardNumber.startIndex])), val != cardProvider.value {
            cardProvider = CardProvider(val: val)
        }
        
        front.update(num: cardNumber, exp: expirationDate, name: nameOnCard)
        back.update(cvv: cvv)
    }
}

// MARK: - BackCardView

class BackCardView: UIView {
    
    // MARK: - BackCardView: Variables
    
    private var CVVLabel = UILabel()
    var spacing: CGFloat {
        bounds.width / 18
    }
    
    var font: UIFont? {
        didSet {
            guard let font = font else { return }
            CVVLabel.font = font
        }
    }
    
    // MARK: - BackCardView: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    // MARK: - BackCardView: Private Functions
    
    private func setup() {
        layer.cornerRadius = 16
        
        CVVLabel.textAlignment = .right
        CVVLabel.frame = CGRect(x: spacing, y: bounds.height / 2 - CVVLabel.font.lineHeight / 2, width: bounds.width - spacing * 2, height: CVVLabel.font.lineHeight)
        
        addSubview(CVVLabel)
    }
    
    private func format(cvv: String) -> String {
        guard let int = Int(cvv), int >= 0 else {
            return "333"
        }
        
        if cvv.count > 4 {
            return String(cvv.dropLast(cvv.count - 4))
        }
        
        return cvv
    }
    
    // MARK: - BackCardView: Public Functions
    
    func update(cvv: String = "") {
        CVVLabel.text = format(cvv: cvv)
    }
}

// MARK: - FrontCardView

class FrontCardView: UIView {
    
    // MARK: - FrontCardView: Variables
    
    private var numberLabel = UILabel()
    private var nameLabel = UILabel()
    private var expirationLabel = UILabel()
    private var providerImageView = UIImageView()
    
    var spacing: CGFloat {
        bounds.width / 18
    }
    
    var font: UIFont? {
        didSet {
            guard let font = font else { return }
            numberLabel.font = font
            nameLabel.font = font
            expirationLabel.font = font
        }
    }
    
    // MARK: - FrontCardView: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    // MARK: - FrontCardView: Private Functions
    
    // Set subview's frames and add to view hierarchy
    private func setup() {
        layer.cornerRadius = 16
        
        let width = bounds.width - spacing * 2
        
        numberLabel.frame = CGRect(x: spacing, y: bounds.height / 2 - numberLabel.font.lineHeight / 2, width: width, height: numberLabel.font.lineHeight)
        expirationLabel.frame = CGRect(x: spacing, y: numberLabel.frame.maxY + spacing, width: width, height: expirationLabel.font.lineHeight)
        nameLabel.frame = CGRect(x: spacing, y: expirationLabel.frame.maxY + spacing, width: width, height: nameLabel.font.lineHeight)
        
        let ratio: CGFloat = 0.2
        let imageWidth = frame.width * ratio
        
        providerImageView.frame = CGRect(x: frame.width - imageWidth - spacing, y: spacing, width: imageWidth, height: frame.height * ratio)
        providerImageView.contentMode = .scaleAspectFill
        
        addSubview(numberLabel)
        addSubview(expirationLabel)
        addSubview(nameLabel)
        addSubview(providerImageView)
    }
    
    private func format(num: String) -> String {
        let stars = String(repeating: "*", count: 16 - num.count)
        let temp = "\(num)\(stars)"
        var number = ""
        
        for i in 0..<temp.count {
            if i % 4 == 0 && i != 0 {
                number += " "
            }
            number += String(temp[temp.index(temp.startIndex, offsetBy: i)])
        }
        
        return number
    }
    
    private func format(exp: Date) -> String {
        if exp == .default {
            return "--/--"
        }
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd"
        
        return df.string(from: exp)
    }
    
    private func format(name: String) -> String {
        if name.isEmpty {
            return "Johnny Appleseed"
        } else {
            return name
        }
    }
    
    // MARK: - FrontCardView: Public Functions
    
    func update(num: String = "", exp: Date = .default, name: String = "") {
        numberLabel.text = format(num: num)
        expirationLabel.text = format(exp: exp)
        nameLabel.text = format(name: name)
    }
    
    func setImage(_ image: UIImage?) {
        providerImageView.image = image
    }
}
