//
//  SetsEditView.swift
//  WorkoutTracker
//
//  Created by TIP on 29.11.22.
//

import SwiftUI

struct SetsEditView: View {

    
    @Binding var data: Workout
    @State var newHowMuch : Float = 0
    @State var newHowLong : Float = 0
    let sizeUnit: SizeUnit
    let lengthUnit: LengthUnit
    
    var body: some View {
        Form {
            Section(header: Text(data.name)){
                ForEach($data.sets) { $set in
                    HStack(spacing: 5){
                    TextField("size", value: $set.howmuch, format: .number)
                        Text(sizeUnit.short).font(.caption)
                    padding()
                    TextField("size", value: $set.howlong, format: .number)
                        Text(lengthUnit.short).font(.caption)
                        Button( action: {
                            if let index = data.sets.firstIndex(of: set) {
                                data.sets.remove(at: index)
                            }

                            
                        })
                        {
                            Image(systemName: "minus.circle.fill")
                        }.buttonStyle(BorderedButtonStyle())
                    }
          
            }
                HStack(spacing: 5) {
                TextField("size", value: $newHowMuch, format: .number)
                    Text(sizeUnit.short).font(.caption)
                padding()
                TextField("length", value: $newHowLong, format: .number)
                    Text(lengthUnit.short).font(.caption)
                Button(action: {
                    withAnimation{
                        let newhm = newHowMuch
                        let newhl = newHowLong
                        let newset = Workout.Set(howmuch: newhm, howlong: newhl)
                        data.sets.append(newset)
                        
                    }
                })
                {
                    Image(systemName: "plus.circle.fill")
                }.buttonStyle(BorderedButtonStyle())
                
            }
            
 
        }
    }
      
    }
    
    struct SetsEditView_Previews: PreviewProvider {
        static var previews: some View {
            SetsEditView(data: .constant(Workout.sampleData[0]), sizeUnit: .lb, lengthUnit: .reps)
        }
    }}

