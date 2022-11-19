//
//  SetEditView.swift
//  WorkoutTracker
//
//  Created by TIP on 18.11.22.
//

import SwiftUI

struct SetEditView: View {
    //@Binding var data = Set.Data()
    @State private var data = Set.Data()
    
    
    
    var body: some View {
        Form {
            Section(header: Text("Set")) {
                TextField("Date", text: $data.name)
            }
            Section(header: Text("Workload")){
                ForEach(data.sets) { sets in
                    HStack {
                        //display sets
                        
                        
                    }
                    
                }
            }
        }
    }
}


struct SetEditView_Previews: PreviewProvider {
        static var previews: some View {
            SetEditView()
    }
}
