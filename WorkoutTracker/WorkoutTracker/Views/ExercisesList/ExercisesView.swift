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
    @State private var isPresentingConfirmDeletionView = false
    @State var selectedExercise: Exercise? = nil
    @Binding var set: [Set]
    
    
    var body: some View {
        List {
            ForEach($exercises) { $exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: $exercise, /*Why parameter set is necesarry here?*/sets: $set)) {
                    ExerciseListItemView(exercise: exercise)
                }.contextMenu {
                    Button(role: .destructive) {
                        selectedExercise = exercise
                        isPresentingConfirmDeletionView = true
                    } label: {
                        Label("Delete Exercise",systemImage: "trash")
                    }
                }.alert(String(format: NSLocalizedString("Are you sure you want to delete exercise \"%@\"?", comment: ""), selectedExercise?.name ?? ""), isPresented: $isPresentingConfirmDeletionView) {
                    Button("Delete Exercise", role: .destructive) {
                        ExercisesService.delete(id: selectedExercise!.id) { didAlsoDeleteCategory in
                            let index: Int? = exercises.firstIndex(where: {selectedExercise!.id == $0.id})
                            
                            DispatchQueue.main.async {
                                exercises.remove(at: index!)
                                if(didAlsoDeleteCategory) {
                                    let categoryIndex: Int? = Exercise.categories.firstIndex {
                                        selectedExercise?.category.id == $0.id}
                                        Exercise.categories.remove(at: categoryIndex!)
                                    isPresentingConfirmDeletionView = false
                                    selectedExercise = nil
                                    }
                                    
                                }
                            }
                        
                    }
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
                                                        ExercisesService.save(exercise: exercise) {isSuccess in
                                                            if(isSuccess) {
                                                                isPresentingNewExerciseView = false
                                                                DispatchQueue.main.async {
                                                                    exercises.append(exercise)
                                                                }
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
            ExercisesView(exercises: .constant(ExercisesService.sampleData.exercises), set: .constant(Set.sampleData))
        }
    }
}
