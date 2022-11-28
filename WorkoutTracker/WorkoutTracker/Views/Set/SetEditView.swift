//
//  SetEditView.swift
//  WorkoutTracker
//
//  Created by TIP on 18.11.22.
//

import SwiftUI

struct SetEditView: View {
    //@Binding var data = Set.Data()
    //@State private var d
    @Binding var data: Set.FormData
    
    @State var newHowMuch : Float = 0
    @State var newHowLong : Float = 0
    
    var body: some View {
        Form {
            Section(header: Text("Workload")){
                ForEach(data.sets) { set in
                    HStack{
                        Text("\(set.howmuch)")
                        //TextField("h", value: set.howmuch, format: .number)
                        padding()
                        Text(String(format: "%.2f", set.howlong))
                    }
                
                    
                }
            }
            HStack {
                TextField("How Much", value: $newHowMuch, format: .number)
                TextField("How Long", value: $newHowLong, format: .number)
                Button(action: {
                    withAnimation{
                        let newhm = newHowMuch
                        let newhl = newHowLong
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
    
    /*struct SetEditView_Previews: PreviewProvider {
        static var previews: some View {
            SetEditView(data: .constant(Set.sampleData[0].data))
        }
    }*/}
