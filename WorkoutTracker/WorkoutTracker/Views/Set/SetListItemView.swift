//
//  SetListItemView.swift
//  WorkoutTracker
//
//  Created by TIP on 25.11.22.
//

import SwiftUI

struct SetListItemView: View {
    let set: Set
    
    var body: some View {
        Text("\(set.id)")
    }
    
}

    


struct SetListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SetListItemView(set: Set.sampleData[0])
    }
}
