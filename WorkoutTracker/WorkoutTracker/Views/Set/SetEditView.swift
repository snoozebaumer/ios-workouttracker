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
    
    var body: some View {
        Form {
            Section(header: Text("Set")) {
                TextField("Date", text: $data.name)
            }
            Section(header: Text("Workload")){
                //ForEach(data.sets) { sets in
                //TextField("Howmuch", text: "\($data.sets)")
                
                
                
                
                
                //}
                
            }
            /*List {
                
                Section(header: Text("Workload")){
                    ForEach(data.sets) { sets in
                        HStack{
                            Text("\(sets.howmuch)")
                            Text("\(sets.howlong)")
                            
                        }
                        //Text("\(sets.howmuch)" + " * \(sets.howlong)")
                        //Text("\(sets.howlong)")
                    
                        
                        
                        
                        
                    }
                }
                
            }*/
        }
    }
}

struct SetEditView_Previews: PreviewProvider {
    static var previews: some View {
        SetEditView(data: .constant(Set.sampleData[0].data))
    }
}
