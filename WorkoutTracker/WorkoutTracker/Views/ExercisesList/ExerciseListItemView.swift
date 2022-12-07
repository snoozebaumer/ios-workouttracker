//
//  ExerciseListItemView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI

struct ExerciseListItemView: View {
    let exercise: Exercise
    @State var hasSetData: Bool = false

    var body: some View {
        HStack(alignment: .center) {
            Text(exercise.name)
                    .font(.headline)
            Spacer()
            HStack {
                Text(getStrongestSetString()).font(.title)
                Text(hasSetData ? exercise.sizeUnit.short : "")
            }

        }
                .padding()
    }

    func getStrongestSetString() -> String {
        let strongestSetString = exercise.getStrongestSetString()
        DispatchQueue.main.async {
            hasSetData = (strongestSetString != "")
        }
        return strongestSetString
    }
}

struct ExerciseListItemView_Previews: PreviewProvider {
    static var exercise = ExercisesService.sampleData.exercises[0]
    static var previews: some View {
        ExerciseListItemView(exercise: exercise)
    }
}
