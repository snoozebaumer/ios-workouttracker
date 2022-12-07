//
//  FilterView.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 06.12.22.
//

import SwiftUI

struct FilterView: View {
    @Binding var filter: Category?
 
    var body: some View {
        Form {
            Section("Filter") {
                Picker("category", selection: $filter) {
                    Text("none").tag(nil as Category?)
                    ForEach(Exercise.categories, id: \.id) { category in
                        Text(category.name).tag(category as Category?)
                    }
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filter: .constant(Category(name: "Back")))
    }
}
