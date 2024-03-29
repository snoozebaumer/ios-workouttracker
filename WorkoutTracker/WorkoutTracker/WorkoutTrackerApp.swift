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
    @State var errorLoading = false;
    @State var error: Error? = nil

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ExercisesView(exercises: $exercisesContext.exercises)
            }
                    .task {
                        do {
                            exercisesContext.exercises = try await ExercisesService.load()
                            for exercise in exercisesContext.exercises {
                                let category = Exercise.categories.first(where: { $0.id == exercise.category.id })
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
                        AlertToast(displayMode: .banner(.slide), type: .error(.red), title: NSLocalizedString("server-error-default", comment: "Title of the server error alert toast"), subTitle: NSLocalizedString("features-restricted", comment: "Message that features may be restricted"))
                    }
        }
    }
}
