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
    @State private var errorInExerciseEditView = false
    @Binding var set: [Set]
    
    
    var body: some View {
        List {
            ForEach($exercises) { $exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: $exercise, /*Why parameter set is necesarry here?*/sets: $set)) {
                    ExerciseListItemView(exercise: exercise)
                }
            }
        }
        .navigationTitle("Exercises")
        .toolbar {
            //plus button did not show without this placement
            ToolbarItemGroup(placement: .navigationBarTrailing){
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
                ExerciseEditView(data: $newExercise, hasConnectionError: $errorInExerciseEditView)
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
                                                        Exercise.save(exercise: exercise) {isSuccess in
                                                            if(isSuccess) {
                                                                isPresentingNewExerciseView = false
                                                                exercises.append(exercise)
                                                    newExercise = Exercise.FormData()
                                                            } else {
                                                                errorInExerciseEditView = true
                                                            }
                                    
                                                        }                       }
                                                }
                    }
            }
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExercisesView(exercises: .constant(Exercise.sampleData), set: .constant(Set.sampleData))
        }
    }
}
