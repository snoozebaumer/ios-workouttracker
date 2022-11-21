//
//  ExerciseEditView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI
import AlertToast

struct ExerciseEditView: View {
    @Binding var data: Exercise.FormData
    @Binding var hasConnectionError: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Exercise Details")) {
                TextField("Name", text: $data.name)
                TextField("Category", text: $data.categoryName)

            }
        }
        .toast(isPresenting: $hasConnectionError, duration: 0) {
            AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "Server error, please try again later.", subTitle: "Exercise was not saved.")
        }
    }
}

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditView(data: .constant(Exercise.sampleData[0].data), hasConnectionError: .constant(false))
    }
}
