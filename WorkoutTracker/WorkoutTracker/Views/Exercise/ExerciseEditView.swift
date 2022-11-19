//
//  ExerciseEditView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI

struct ExerciseEditView: View {
    @Binding var data: Exercise.FormData
    
    var body: some View {
        Form {
            Section(header: Text("Exercise Details")) {
                TextField("Name", text: $data.name)
                TextField("Category", text: $data.categoryName)

            }
        }
    }
}

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditView(data: .constant(Exercise.sampleData[0].data))
    }
}
