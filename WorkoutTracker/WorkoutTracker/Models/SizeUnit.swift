//
//  SizeUnit.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 01.12.22.
//

import Foundation

enum SizeUnit: Int, Codable, Equatable, CaseIterable {
    case kg = 0
    case lb = 1
    case km = 2
    case mi = 3
    case m = 4
    
    var localizableKey: String {
        switch self {
        case .kg: return "kilograms"
        case .lb: return "pounds"
        case .km: return "kilometres"
        case .mi: return "miles"
        case .m: return "metres"
        }
    }
    
    var short: String {
        switch self {
        case .kg: return "kg"
        case .lb: return "lb"
        case .km: return "km"
        case .mi: return "mi"
        case .m: return "m"
        }
    }
}
