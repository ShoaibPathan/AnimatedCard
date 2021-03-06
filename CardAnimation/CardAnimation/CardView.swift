//
//  CardView.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/21/20.
//

import UIKit

// MARK: - CardView

@IBDesignable
class CardView: UIView {
    
    // MARK: - CardView: Variables
    
    var cardNumber: String {
        front.getCardNumber()
    }
    
    var expiration: Date {
        front.getExpiration()
    }
    
    var cvv: String {
        back.getCVV()
    }
    
    var cardProvider: CardProvider {
        return provider
    }
    
    private var provider: CardProvider = .none {
        didSet {
            updateCard()
        }
    }
    private var monoFont: UIFont? {
        didSet {
            guard let font = monoFont else { return }
            front.font = font
            back.font = font
        }
    }
    
    private var isFlipped = false
    private var duration: Double = 0.5
    
    private var front: FrontCardView!
    private var back: BackCardView!
    
    override var frame: CGRect {
        didSet {
            updateFrame()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateFrame()
        }
    }
    
    // MARK: - CardView: Initializers
    
    convenience init(origin: CGPoint, height: CGFloat) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: 1.586 * height, height: height)))
    }
    
    convenience init(origin: CGPoint, width: CGFloat) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: width, height: width / 1.586)))
    }
    
    private override init(frame: CGRect) {
        let tempFrame = CGRect(origin: .zero, size: frame.size)
        
        front = FrontCardView(frame: tempFrame)
        back = BackCardView(frame: tempFrame)
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        front = FrontCardView(frame: .zero)
        back = BackCardView(frame: .zero)
        
        super.init(coder: coder)

        setup()
    }
    
    // MARK: - CardView: Private Functions
    
    private func setup() {
        update()
        updateCard()
        updateFrame()
        
        monoFont = .monospacedSystemFont(ofSize: frame.width / 19, weight: .black)
        
        addSubview(front)
        addSubview(back)
        
        let viewToHide = isFlipped ? front : back
        viewToHide?.isHidden = true
    }
    
    private func updateCard() {
        front.backgroundColor = cardProvider.color
        back.backgroundColor = cardProvider.color
        front.setImage(cardProvider.image)
        
    }
    
    private func updateFrame() {
        // Create frame for card subviews based on smaller dimension of card to maintain aspect ratio
        let newBounds = CGRect(origin: .zero, size: frame.width > frame.height ? CGSize(width: 1.586 * frame.height, height: frame.height) : CGSize(width: frame.width, height: frame.width / 1.586))
        
        front.frame = newBounds
        back.frame = newBounds
        
        front.updateFrames()
        back.updateFrames()
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
    func update(cardNumber: String? = nil, expirationDate: Date = .default, nameOnCard: String? = nil, cvv: String? = nil) {
        if let cardNumber = cardNumber, cardNumber.count > 0, let val = Int(String(cardNumber[cardNumber.startIndex])), val != cardProvider.value {
            provider = CardProvider(val: val)
        } else if let cardNumber = cardNumber, cardNumber.isEmpty {
            provider = .none
        }
        
        front.update(num: cardNumber, exp: expirationDate, name: nameOnCard)
        back.update(cvv: cvv)
    }
}

// MARK: - BackCardView

class BackCardView: UIView {
    
    // MARK: - BackCardView: Variables
    
    var font: UIFont? {
        didSet {
            guard let font = font else { return }
            CVVLabel.font = font
        }
    }
    
    private var cvv: String = "" {
        didSet {
            CVVLabel.text = format(cvv: cvv)
        }
    }
    
    private var CVVLabel = UILabel()
    
    private var spacing: CGFloat {
        bounds.width / 18
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
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(x: 0, y: rect.minY + rect.height / 8, width: rect.width, height: rect.height / 5))
    }
    
    // MARK: - BackCardView: Private Functions
    
    private func setup() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        updateFrames()
        
        CVVLabel.textAlignment = .right
        
        addSubview(CVVLabel)
        
        CVVLabel.text = format(cvv: "")
    }
    
    func updateFrames() {
        CVVLabel.frame = CGRect(x: spacing, y: bounds.height / 2 - CVVLabel.font.lineHeight / 2, width: bounds.width - spacing * 2, height: CVVLabel.font.lineHeight)
    }
    
    private func format(cvv: String) -> String {
        guard let int = Int(cvv), int > 0 else {
            return "***"
        }
        
        if cvv.count > 4 {
            return String(cvv.dropLast(cvv.count - 4))
        } else if cvv.count < 3 {
            var str = cvv
            
            for _ in 0..<3 - str.count {
                str += "*"
            }
            
            return str
        }
        
        return cvv
    }
    
    // MARK: - BackCardView: Public Functions
    
    func update(cvv: String? = nil) {
        if let cvv = cvv {
            CVVLabel.text = format(cvv: cvv)
        }
    }
    
    func getCVV() -> String {
        return cvv
    }
}

// MARK: - FrontCardView

class FrontCardView: UIView {
    
    // MARK: - FrontCardView: Variables
    
    private var numberLabel = UILabel()
    private var nameLabel = UILabel()
    private var expirationLabel = UILabel()
    private var providerImageView = UIImageView()
    
    private var cardNum: String = "" {
        didSet {
            numberLabel.text = format(number: cardNum)
        }
    }
    
    private var name: String = "" {
        didSet {
            nameLabel.text = format(name: name)
        }
    }
    
    private var exp: Date = .default {
        didSet {
            expirationLabel.text = format(exp: exp)
        }
    }
    
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
        
        updateFrames()
        
        providerImageView.contentMode = .scaleAspectFit
        
        addSubview(numberLabel)
        addSubview(expirationLabel)
        addSubview(nameLabel)
        addSubview(providerImageView)
        
        numberLabel.text = format(number: "")
        expirationLabel.text = format(exp: .default)
        nameLabel.text = format(name: "")
    }
    
    func updateFrames() {
        let width = bounds.width - spacing * 2
        
        numberLabel.frame = CGRect(x: spacing, y: bounds.height / 2 - numberLabel.font.lineHeight / 2, width: width, height: numberLabel.font.lineHeight)
        
        expirationLabel.frame = CGRect(x: spacing, y: numberLabel.frame.maxY + spacing, width: width, height: expirationLabel.font.lineHeight)
        
        nameLabel.frame = CGRect(x: spacing, y: expirationLabel.frame.maxY + spacing, width: width, height: nameLabel.font.lineHeight)
        
        let ratio: CGFloat = 0.2
        let imageWidth = frame.width * ratio
        
        providerImageView.frame = CGRect(x: frame.width - imageWidth - spacing, y: spacing, width: imageWidth, height: frame.height * ratio)
    }
    
    private func format(number: String) -> String {
        var num = number
        
        if num.count > 16 {
            num = String(number.dropLast(number.count - 16))
        }
        
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
        df.dateFormat = "MM/yy"
        
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
    
    func update(num: String? = nil, exp: Date = .default, name: String? = nil) {
        if let num = num {
            self.cardNum = num
        }
        
        if exp != .default {
            self.exp = exp
        }
        
        if let name = name {
            self.name = name
        }
    }
    
    func setImage(_ image: UIImage?) {
        providerImageView.image = image
    }
    
    func getName() -> String {
        return name
    }
    
    func getExpiration() -> Date {
        return exp
    }
    
    func getCardNumber() -> String {
        return cardNum
    }
}
