//
//  SetListItemView.swift
//  WorkoutTracker
//
//  Created by TIP on 25.11.22.
//

import SwiftUI

struct WorkoutListItemView: View {
    @Binding var set: Workout
    let lengthUnit: LengthUnit
    let sizeUnit: SizeUnit
    
    var body: some View {
        VStack{
                 Text(set.name)
                .font(.headline)
                 VStack {
                     ForEach(set.sets) {s in
                         HStack{
                             Text(String(format: "%.1f", s.howmuch) + " " + sizeUnit.short)
                         Text(" x ")
                         Text(String(format: "%.2f", s.howlong) + " " + lengthUnit.short)
                         }
                         .padding(.leading)
                     }
                     
                 }
                 .font(.caption)
        }
        
 
            
        }
        
    }
    




    


struct SetListItemView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListItemView(set: .constant(Workout.sampleData[0]), lengthUnit: .reps, sizeUnit: .kg)
    }
}
