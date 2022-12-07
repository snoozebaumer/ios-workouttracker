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
    @State var isPresentingConfirmDeletionView = false
    @State var isPresentingFilterView = false
    
    @State var newExercise = Exercise.FormData()
    @State var errorInExerciseEditView = false
    
    @State var selectedExercise: Exercise? = nil
    @State var isFilterActive: Bool = false
    @State var newFilter: Category? = nil
    @State var filteredExercises: [Exercise] = []
    var filter: Category? = nil
  
    
    
    
    var body: some View {
        List {
            ForEach(!isFilterActive ? $exercises : $filteredExercises) { $exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: $exercise)) {
                    ExerciseListItemView(exercise: exercise)
                }.contextMenu {
                    Button(role: .destructive) {
                        selectedExercise = exercise
                        isPresentingConfirmDeletionView = true
                    } label: {
                        Label("delete-exercise",systemImage: "trash")
                    }
                }.alert(String(format: NSLocalizedString("deletion-confirmation", comment: "The deletion confirmation dialog for exercises"), selectedExercise?.name ?? ""), isPresented: $isPresentingConfirmDeletionView) {
                    Button(NSLocalizedString("delete-exercise", comment: "Second deletion confirmation button"), role: .destructive) {
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
        .navigationTitle("exercises")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Button(action: {
                    isPresentingFilterView = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(filter != nil ? .green : .accentColor)
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
                     Button(NSLocalizedString("dismiss", comment: "Dismiss Button")) {
                         isPresentingNewExerciseView = false
                         newExercise = Exercise.FormData()
                                                    }
                                                }
                        ToolbarItem(placement: .confirmationAction) {
                                                    Button(NSLocalizedString("add", comment: "Add Button")) {
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
        .sheet(isPresented: $isPresentingFilterView) {
            NavigationView {
                FilterView(filter: $newFilter)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(NSLocalizedString("dismiss", comment: "Dismiss Button")) {
                                isPresentingFilterView = false
                                                           }
                        }
                        ToolbarItemGroup(placement: .confirmationAction) {
                            Button {
                                
                            } label: {
                                Label("apply-filter", systemImage: "line.3.horizontal.decrease")
                            }
                            Button {
                                
                            } label: {
                                Label("show-random-exercise", systemImage: "shuffle")
                            }
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button("clear-filter") {
                                
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
            ExercisesView(exercises: .constant(ExercisesService.sampleData.exercises))
        }
    }
}
