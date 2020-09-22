//
//  CardType.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/21/20.
//

import UIKit

enum CardProvider: String {
    case americanExpress = "amex"
    case visa = "visa"
    case masterCard = "master"
    case discover
    case none
    
    init(val: Int) {
        switch val {
        case 3:
            self = .americanExpress
        case 4:
            self = .visa
        case 5:
            self = .masterCard
        case 6:
            self = .discover
        default:
            self = .none
        }
    }
    
    var value: Int {
        switch self {
        case .americanExpress:
            return 3
        case .visa:
            return 4
        case .masterCard:
            return 5
        case .discover:
            return 6
        default:
            return -1
        }
    }
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
    
    var color: UIColor {
        switch self {
        case .americanExpress:
            return .amex
        case .visa:
            return .visa
        case .masterCard:
            return .master
        case .discover:
            return .discover
        default:
            return .lightGray
        }
    }
}
