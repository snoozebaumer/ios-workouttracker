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
            Section(header: Text("exercise-details")) {
                TextField("name", text: $data.name)
                TextField("category", text: $data.categoryName)
                Picker("sizeUnit", selection: $data.sizeUnit) {
                    ForEach(SizeUnit.allCases, id: \.self) { value in
                        Text(NSLocalizedString(value.localizableKey, comment: "Localization of enum value")).tag(value)
                    }
                }

                Picker("lengthUnit", selection: $data.lengthUnit) {
                    ForEach(LengthUnit.allCases, id: \.self) { value in
                        Text(NSLocalizedString(value.localizableKey, comment: "Localization of enum value")).tag(value)
                    }
                }
            }
        }
                .toast(isPresenting: $hasConnectionError, duration: 0) {
                    AlertToast(displayMode: .banner(.slide), type: .error(.red), title: NSLocalizedString("server-error-default", comment: "Title of the server error alert toast"), subTitle: NSLocalizedString("features-restricted", comment: "Message that features may be restricted"))
                }
    }
}

struct ExerciseEditView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditView(data: .constant(ExercisesService.sampleData.exercises[0].data), hasConnectionError: .constant(false))
    }
}
