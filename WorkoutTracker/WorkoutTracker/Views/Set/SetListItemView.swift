//
//  SetListItemView.swift
//  WorkoutTracker
//
//  Created by TIP on 25.11.22.
//

import SwiftUI

struct SetListItemView: View {
    @Binding var set: Set
    
    var body: some View {
        VStack{
                 Text(set.name)
                .font(.subheadline)
                 VStack {
                     ForEach(set.sets) {s in
                         HStack{
                         Text(String(format: "%.2f", s.howmuch))
                         Text(" x ")
                         Text(String(format: "%.2f", s.howlong))
                         }
                     }
                     
                 }
                 .font(.caption)
        }
        
 
            
        }
        
    }
    




    


/*struct SetListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SetListItemView(set: Set.sampleData[0])
    }*/

