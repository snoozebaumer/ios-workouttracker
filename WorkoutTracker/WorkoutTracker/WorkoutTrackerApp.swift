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
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ExercisesView(exercises: $exercises)
            }
        }
    }
}
