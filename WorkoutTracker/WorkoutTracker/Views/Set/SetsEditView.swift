//
//  SetsEditView.swift
//  WorkoutTracker
//
//  Created by TIP on 29.11.22.
//

import SwiftUI

struct SetsEditView: View {

    
    @Binding var data: Set
    @State var newHowMuch : Float = 0
    @State var newHowLong : Float = 0
    

    
    var body: some View {
        Form {
            Section(header: Text(data.name)){
                ForEach($data.sets) { $set in
                    HStack{
                    TextField("size", value: $set.howmuch, format: .number)
                    padding()
                    TextField("size", value: $set.howlong, format: .number)
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
            HStack {
                TextField("size", value: $newHowMuch, format: .number)
                padding()
                TextField("length", value: $newHowLong, format: .number)
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
                }.buttonStyle(BorderedButtonStyle())
                
            }
            
 
        }
    }
      
    }
    
    struct SetsEditView_Previews: PreviewProvider {
        static var previews: some View {
            SetsEditView(data: .constant(Set.sampleData[0]))
        }
    }}

