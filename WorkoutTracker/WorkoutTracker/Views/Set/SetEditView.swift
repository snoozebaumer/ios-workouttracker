//
//  SetEditView.swift
//  WorkoutTracker
//
//  Created by TIP on 18.11.22.
//

import SwiftUI

struct SetEditView: View {
    //@Binding var data = Set.Data()
    @Binding var data: Set.FormData
    @State private var newHowMuch = ""
    @State private var newHowLong = ""
    
    var body: some View {
        Form {
            Section(header: Text("Workload")){
                ForEach(data.sets) { sets in
                    HStack{
                        //Text("\(sets.howmuch)")
                        Text(String(format: "%.2f", sets.howmuch))
                        padding()
                        Text(String(format: "%.2f", sets.howlong))
                    }
                
                    
                }
            }
            HStack {
                TextField("How Much", text: $newHowMuch )
                TextField("How Long", text: $newHowLong )
                Button(action: {
                    withAnimation{
                        let newhm = Float(newHowMuch) ?? 0.0
                        let newhl = Float(newHowLong) ?? 0.0
                        let newset = Set.Sets(howmuch: newhm, howlong: newhl)
                        data.sets.append(newset)
                    }
                })
                {
                    Image(systemName: "plus.circle.fill")
                }
                
            }
            
 
        }
    }
    
    struct SetEditView_Previews: PreviewProvider {
        static var previews: some View {
            SetEditView(data: .constant(Set.sampleData[0].data))
        }
    }}
