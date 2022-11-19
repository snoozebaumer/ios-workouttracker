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
            Section(header: Text("Sets")) {
                //TODO: Add Set List
                Button("New") {
                    isPresentingEditView = true
                }
            }
        }
        .navigationTitle(exercise.name)
        //.sheet --> to add setss
 
        
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                ExerciseEditView(data: $data)
                    .navigationTitle(exercise.name)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                exercise.update(from: data)
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
            ExerciseDetailView(exercise: .constant(Exercise.sampleData[0]))
        }
    }
}
