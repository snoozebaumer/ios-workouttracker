//
//  ExercisesView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI

struct ExercisesView: View {
    @Binding var exercises: [Exercise]
    @State var isPresentingNewExerciseView = false;
    @State private var newExercise = Exercise.FormData()
    
    var body: some View {
        List {
            ForEach($exercises) { $exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: $exercise)) {
                    ExerciseListItemView(exercise: exercise)
                }
            }
        }
        .navigationTitle("Exercises")
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    // TODO: filter
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                Button(action: {
                            isPresentingNewExerciseView = true
                        }) {
                            Image(systemName: "plus")
                    }
            }
                }
        .sheet(isPresented: $isPresentingNewExerciseView) {
            NavigationView {
                ExerciseEditView(data: $newExercise)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                     Button("Dismiss") {
                         isPresentingNewExerciseView = false
                         newExercise = Exercise.FormData()
                                                    }
                                                }
                        ToolbarItem(placement: .confirmationAction) {
                                                    Button("Add") {
                                                        let exercise = Exercise(data: newExercise)
                                                        exercises.append(exercise)
                                                        Exercise.save(exercise: exercise)
                                                        isPresentingNewExerciseView = false
                                                        newExercise = Exercise.FormData()
                                                    }
                                                }
                    }
            }
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExercisesView(exercises: .constant(Exercise.sampleData))
        }
    }
}
