//
//  ExerciseListItemView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import SwiftUI

struct ExerciseListItemView: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(alignment: .center) {
            Text(exercise.name)
                .font(.headline)
            Spacer()
            HStack {
                //TODO: replace with set data
                Text("10").font(.title)
                Text("kg")
            }
            
        }.padding()
    }
}

struct ExerciseListItemView_Previews: PreviewProvider {
    static var exercise = Exercise.sampleData[0]
    static var previews: some View {
        ExerciseListItemView(exercise: exercise)
    }
}
