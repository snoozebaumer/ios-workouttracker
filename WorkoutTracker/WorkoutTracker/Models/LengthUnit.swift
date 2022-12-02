//
//  LengthUnit.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 01.12.22.
//

import Foundation

enum LengthUnit: Int, Codable,Equatable, CaseIterable {
    case reps = 0
    case min = 1
    case sec = 2
    case km = 3
    case m = 4
    
    var localizableKey: String {
        switch self {
        case .reps: return "reps"
        case .min: return "minutes"
        case .sec: return "seconds"
        case .km: return "kilometres"
        case .m: return "metres"
        }
    }
    
    var short: String {
        switch self {
        case .reps: return "reps"
        case .min: return "min"
        case .sec: return "sec"
        case .km: return "km"
        case .m: return "m"
        }
    }
}
