//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI
import AlertToast

@main
struct WorkoutTrackerApp: App {
    @StateObject var exercisesContext = ExercisesService()
    /*Why parameter set is necesarry here?*/
    @State var sets: [Set] = []
    @State var errorLoading = false;
    @State var error: Error? = nil
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ExercisesView(exercises: $exercisesContext.exercises, set: $sets)
            }
            .task {
                do {
                    exercisesContext.exercises = try await ExercisesService.load()
                    for exercise in exercisesContext.exercises {
                        let category = Exercise.categories.first(where: {$0.id == exercise.category.id})
                        if category != nil {
                            continue
                        } else {
                            Exercise.categories.append(exercise.category)
                        }
                    }
                } catch {
                    errorLoading = true;
                    self.error = error
                }
            }
            .toast(isPresenting: $errorLoading, duration: 5) {
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: error?.localizedDescription ?? "Server error, please try again later.", subTitle: "Features may be restricted during usage.")
            }
        }
    }
}
