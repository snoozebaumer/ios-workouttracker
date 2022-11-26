//
//  ExerciseDetailView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI

struct ExerciseDetailView: View {
    @Binding var exercise: Exercise
    @State private var data = Exercise.FormData()
    @State private var isPresentingEditView = false
    @State private var errorInExerciseEditView = false;
    
    @Binding var sets: [Set]
    @State private var isPresentingNewSetView = false;
    @State private var newSet = Set.FormData()
    
    //@State private var newSet = Exercise.SetFormData()

    
    
    
    
    //same as above to add sets
    
    var body: some View {
        List {
            Section(header: Text("Exercise Details")) {
                HStack {
                                    Label("Category", systemImage: "figure.arms.open")
                                    Spacer()
                    Text(exercise.category.name)
                                }
            }
            Button("New") {
                isPresentingNewSetView = true
            }
            Section(header: Text("Sets")) {
            
                    ForEach(sets) { Set in
             
                            SetListItemView(set: Set)
                     
                         }
                
                
               
            }
        }
        .navigationTitle(exercise.name)
        
        // Sheet to add sets
        .sheet(isPresented: $isPresentingNewSetView) {
            NavigationView {
                SetEditView(data: $newSet)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewSetView = false
                                
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let set = Set(data: newSet)
                                sets.append(set)
                                newSet = Set.FormData()
                                isPresentingNewSetView = false
        
                                
                            }
                        }
                    }
            }
        }
        
        
        
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                ExerciseEditView(data: $data, hasConnectionError: $errorInExerciseEditView)
                    .navigationTitle(exercise.name)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                Task {
                                    await exercise.update(from: data) {
                                        isSuccess in
                                        if (isSuccess) {
                                            isPresentingEditView = false
                                        } else {
                                            errorInExerciseEditView = true
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
        .toolbar {
                    Button("Edit") {
                        isPresentingEditView = true
                        data = exercise.data
                    }
                }
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExerciseDetailView(exercise: .constant(ExercisesService.sampleData.exercises[0]), sets: .constant(Set.sampleData))
        }
    }
}
