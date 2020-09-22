//
//  Month.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/21/20.
//

import Foundation

enum Month: Int {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    case none
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .january
        case 1:
            self = .february
        case 2:
            self = .march
        case 3:
            self = .april
        case 4:
            self = .may
        case 5:
            self = .june
        case 6:
            self = .july
        case 7:
            self = .august
        case 8:
            self = .september
        case 9:
            self = .october
        case 10:
            self = .november
        case 11:
            self = .december
        default:
            self = .none
        }
    }
    
    var string: String {
        let str: String
        
        switch self {
        case .january:
            str = "January"
        case .february:
            str = "February"
        case .march:
            str = "March"
        case .april:
            str = "April"
        case .may:
            str = "May"
        case .june:
            str = "June"
        case .july:
            str = "July"
        case .august:
            str = "August"
        case .september:
            str = "September"
        case .october:
            str = "October"
        case .november:
            str = "November"
        case .december:
            str = "December"
        default:
            str = "~ERROR~ Invalid month"
        }
        
        return str
    }
}
