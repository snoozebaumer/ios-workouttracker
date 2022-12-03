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
    @State private var isPresentingNewWorkoutView = false;
    @State private var newWorkout = Workout.FormData()
    @State var sets: [Float] = []
    @State var changedWorkout : Workout? = nil
    @State var originalWorkout : Workout? = nil
    @State private var isPresentigSetsEditView = false;
    @State var selectedWorkout: Workout? = nil
    @State private var isPresentingConfirmSetDeletionView = false
    @State private var errorInNewWorkoutView = false
    
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
                isPresentingNewWorkoutView = true
            }
            
            Section(header: Text("sets")) {
            
                ForEach($exercise.workouts) { $eset in
                    
                    WorkoutListItemView(set: $eset, lengthUnit: exercise.lengthUnit, sizeUnit: exercise.sizeUnit).onTapGesture{
                        changedWorkout = eset
                        originalWorkout = changedWorkout
                        isPresentigSetsEditView = true
                    }.contextMenu{
                        Button(role: .destructive) {
                            selectedWorkout = eset
                            isPresentingConfirmSetDeletionView = true
                        } label: {
                            Label("delete-set",systemImage: "trash")
                            
                        }
                    }.alert(NSLocalizedString("deletion-confirmation-set", comment: "Deletion confirmation for Set"), isPresented: $isPresentingConfirmSetDeletionView) {
                        Button("delete-set", role: .destructive) {
                            //To-Do: Implement like deleteexercise once server for set is implemented
                            let index: Int? = exercise.workouts.firstIndex(where: {eset.id == $0.id})
                            exercise.workouts.remove(at: index!)
                            
                            
                        }
                    }
                }
                
            }
            
            
            
            
        }
        .navigationTitle(exercise.name)
        
        
        .sheet(isPresented: $isPresentingNewWorkoutView) {
            NavigationView {
                WorkoutEditView(data: $newWorkout, sizeUnit: exercise.sizeUnit, lengthUnit: exercise.lengthUnit)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("dismiss") {
                                isPresentingNewWorkoutView = false
                                newWorkout = Workout.FormData()
                                
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("add") {
                                var workout = Workout(data: newWorkout)
                                workout.updateExerciseID(from: exercise.id)
                                let finalWorkout = workout
                                //exercise.updateSet(set: finalWorkout)
                                //send Workout to server
                                WorkoutsService.save(workout: finalWorkout) { isSucess in
                                    if(isSucess) {
                                        isPresentingNewWorkoutView = false
                                        DispatchQueue.main.async {
                                            exercise.updateWorkout(workout: finalWorkout)
                                        }
                                        newWorkout = Workout.FormData()
                                    } else {
                                        errorInNewWorkoutView = true
                                    }
                                
                                    
                                }
                                //newSet = Workout.FormData()
                                //isPresentingNewWorkoutView = false
                                
                                
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
                SetsEditView(data: Binding($changedWorkout)!, sizeUnit: exercise.sizeUnit, lengthUnit: exercise.lengthUnit)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("cancel") {
                                isPresentigSetsEditView = false
                                
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("done") {
                                exercise.changeWorkout(originalWorkout: originalWorkout!, changedWorkout: changedWorkout!)
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
            ExerciseDetailView(exercise: .constant(ExercisesService.sampleData.exercises[0]))
        }
    }

}
