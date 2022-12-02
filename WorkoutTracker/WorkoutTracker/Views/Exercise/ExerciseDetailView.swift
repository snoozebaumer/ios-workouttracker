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
    @State private var isPresentigSetEditView = false;
    
    @State var changedSet : Set = Set(/*excercise: "Test", strenght: true, metric: true, */sets:[4,2])
    @State var originalSet : Set = Set(/*excercise: "Test", strenght: true, metric: true, */sets:[4,2])
    
    
    
    @State private var isPresentigSetsEditView = false;
    @State var selectedSet: Set? = nil
    @State private var isPresentingConfirmSetDeletionView = false
    
    
    //same as above to add sets
    
    var body: some View {
        List {
            Section(header: Text("exercise-details")) {
                HStack {
                    Label("category", systemImage: "figure.arms.open")
                    Spacer()
                    Text(exercise.category.name)
                }
                HStack {
                    Label("sizeUnit", systemImage: "scalemass.fill")
                    Spacer()
                    Text(NSLocalizedString(exercise.sizeUnit.localizableKey, comment: "Localization of Sizeunit"))
                }
                HStack {
                    Label("lengthUnit", systemImage: "stopwatch.fill")
                    Spacer()
                    Text(NSLocalizedString(exercise.lengthUnit.localizableKey, comment: "Localization of LengthUnit"))
                }
            }
            Button("new-set") {
                isPresentingNewSetView = true
            }
            
            Section(header: Text("sets")) {
            
                ForEach($exercise.eSet) { $eset in
                    
                    SetListItemView(set: $eset, lengthUnit: exercise.lengthUnit, sizeUnit: exercise.sizeUnit).onTapGesture{
                        changedSet = eset
                        originalSet = changedSet
                        isPresentigSetsEditView = true
                    }.contextMenu{
                        Button(role: .destructive) {
                            selectedSet = eset
                            isPresentingConfirmSetDeletionView = true
                        } label: {
                            Label("delete-set",systemImage: "trash")
                            
                        }
                    }.alert(NSLocalizedString("deletion-confirmation-set", comment: "Deletion confirmation for Set"), isPresented: $isPresentingConfirmSetDeletionView) {
                        Button("delete-set", role: .destructive) {
                            //To-Do: Implement like deleteexercise once server for set is implemented
                            let index: Int? = exercise.eSet.firstIndex(where: {eset.id == $0.id})
                            exercise.eSet.remove(at: index!)
                            
                            
                        }
                    }
                }
                
            }
            
            
            
            
        }
        .navigationTitle(exercise.name)
        
        
        // Sheet to add sets
        .sheet(isPresented: $isPresentingNewSetView) {
            NavigationView {
                SetEditView(data: $newSet, sizeUnit: exercise.sizeUnit, lengthUnit: exercise.lengthUnit)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("dismiss") {
                                isPresentingNewSetView = false
                                newSet = Set.FormData()
                                
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("add") {
                                let set = Set(data: newSet)
                                //sets.append(set)
                                exercise.updateSet(set: set)
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
                            Button("cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("done") {
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
            Button("edit") {
                isPresentingEditView = true
                data = exercise.data
            }
        }
        
        .sheet(isPresented: $isPresentigSetsEditView) {
            NavigationView {
                SetsEditView(data: $changedSet, sizeUnit: exercise.sizeUnit, lengthUnit: exercise.lengthUnit)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("cancel") {
                                isPresentigSetsEditView = false
                                
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("done") {
                                exercise.changeSet(originalSet: originalSet, changedSet: changedSet)
                                isPresentigSetsEditView = false
                                
                                
                            }
                        }
                    }
                
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
