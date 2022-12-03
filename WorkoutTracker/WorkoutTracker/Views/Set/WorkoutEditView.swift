//
//  SetEditView.swift
//  WorkoutTracker
//
//  Created by TIP on 18.11.22.
//

import SwiftUI
import AlertToast


struct WorkoutEditView: View {
    //@Binding var data = Set.Data()
    //@State private var d
    @Binding var data: Workout.FormData
    @State var newHowMuch : Float = 0
    @State var newHowLong : Float = 0
    @State private var isPresentingSetsEditView = false
    let sizeUnit: SizeUnit
    let lengthUnit: LengthUnit

    var body: some View {
            Form {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 5) {
                            Text("size")
                            Text("(" + sizeUnit.short + ")")
                        }.font(.caption)
                        TextField("size", value: $newHowMuch, format: .number)
                    }
                    VStack(alignment: .leading) {
                        HStack(spacing: 5) {
                            Text("length")
                            Text("(" + lengthUnit.short + ")")
                        }.font(.caption)
                        TextField("length", value: $newHowLong, format: .number)
                    }
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

                Section(header: Text("workload")){
                    ForEach(data.sets) { set in
                        HStack{
                            Text(String(format: "%.2f", set.howmuch) + " " + sizeUnit.short)
                            padding()
                            Text(String(format: "%.2f", set.howlong))
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
                }
            }
    }
    }



    
    struct SetEditView_Previews: PreviewProvider {
        static var previews: some View {
            WorkoutEditView(data: .constant(Workout.sampleData[0].data),sizeUnit: .kg, lengthUnit: .reps)
        }
    }

