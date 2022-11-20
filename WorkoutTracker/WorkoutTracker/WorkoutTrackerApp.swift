//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI

@main
struct WorkoutTrackerApp: App {
    @State var exercises: [Exercise] = []
    /*Why parameter set is necesarry here?*/
    @State var sets: [Set] = []
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ExercisesView(exercises: $exercises, /*Why parameter set is necesarry here?*/set: $sets)
            }
        }
    }
}
