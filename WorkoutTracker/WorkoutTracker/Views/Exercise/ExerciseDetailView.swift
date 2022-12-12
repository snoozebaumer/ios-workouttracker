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
    @State private var newWorkoutData = Workout.FormData()
    @State private var changeWorkoutId: UUID? = nil
    @State private var changeWorkoutData = Workout.FormData()
    @State var sets: [Float] = []
    @State private var isPresentingWorkoutEditView = false;
    @State var selectedWorkout: Workout? = nil
    @State private var isPresentingConfirmSetDeletionView = false
    @State private var errorInNewWorkoutView = false

    var body: some View {
        List {
            Section(header: Text("exercise-details")) {
                HStack {
                    Label("category", systemImage: "dumbbell.fill")
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
            Button("new-workout") {
                isPresentingNewWorkoutView = true
            }
            Section(header: Text("workouts")) {
                ForEach($exercise.workouts) { $workout in
                    WorkoutListItemView(workout: $workout, lengthUnit: exercise.lengthUnit, sizeUnit: exercise.sizeUnit).onTapGesture {
                                changeWorkoutData.sets = workout.sets
                                changeWorkoutId = workout.id
                                isPresentingWorkoutEditView = true
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    selectedWorkout = workout
                                    isPresentingConfirmSetDeletionView = true
                                } label: {
                                    Label("delete-workout", systemImage: "trash")

                                }
                            }
                            .alert(NSLocalizedString("deletion-confirmation-workout", comment: "Deletion confirmation for Workout"), isPresented: $isPresentingConfirmSetDeletionView) {
                                Button("delete-workout", role: .destructive) {
                                    ExercisesService.deleteWorkout(id: workout.id)
                                    let index: Int? = exercise.workouts.firstIndex(where: { workout.id == $0.id })
                                    exercise.workouts.remove(at: index!)
                                    isPresentingConfirmSetDeletionView = false
                                    selectedWorkout = nil
                                        
                                    
                                    
                                    
                                
                                    
                                
                                    
                                }
                            }
                }
            }
        }
                .navigationTitle(exercise.name)
                .sheet(isPresented: $isPresentingNewWorkoutView) {
                    NavigationView {
                        WorkoutEditView(data: $newWorkoutData, sizeUnit: exercise.sizeUnit, lengthUnit: exercise.lengthUnit)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("dismiss") {
                                            isPresentingNewWorkoutView = false
                                            newWorkoutData = Workout.FormData()

                                        }
                                    }
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("add") {
                                            var workout = Workout(data: newWorkoutData)
                                            workout.updateExerciseID(from: exercise.id)
                                            let finalWorkout = workout
                                         
                                            exercise.addWorkout(workout: finalWorkout)
                                            Task {
                                                await exercise.updateWorkout() {
                                                    isSuccess in
                                                    if (isSuccess) {
                                                        isPresentingNewWorkoutView = false
                                                    } else {
                                                        errorInNewWorkoutView = true
                                                    }
                                                }
                                            }
                                            newWorkoutData = Workout.FormData()
                                   

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
                .sheet(isPresented: $isPresentingWorkoutEditView) {
                    NavigationView {
                        WorkoutEditView(data: $changeWorkoutData, sizeUnit: exercise.sizeUnit, lengthUnit: exercise.lengthUnit)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("cancel") {
                                            isPresentingWorkoutEditView = false
                                        }
                                    }
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("done") {
                                            exercise.changeWorkout(id: changeWorkoutId!, data: changeWorkoutData)
                                            changeWorkoutId = nil
                                            isPresentingWorkoutEditView = false
                                            Task {
                                                await exercise.updateWorkout() {
                                                    isSuccess in
                                                    if (isSuccess) {
                                                        isPresentingNewWorkoutView = false
                                                    } else {
                                                        errorInNewWorkoutView = true
                                                    }
                                                }
                                            }
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
