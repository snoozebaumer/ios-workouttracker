//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI

@main
struct WorkoutTrackerApp: App {
    @StateObject var exercisesContext = ExercisesService()
    /*Why parameter set is necesarry here?*/
    @State var sets: [Set] = []
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ExercisesView(exercises: $exercisesContext.exercises, set: $sets)
            }
        }
    }
}
