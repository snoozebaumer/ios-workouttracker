//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 15.11.22.
//

import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: Category
    
    init(id: UUID = UUID(), title: String, category: Category) {
        self.id = id
        self.name = title
        self.category = category
    }
    
}

extension Exercise {
    init(id: UUID = UUID(), data: FormData) {
        self.id = id;
        self.name = data.name
        let existingCategory = Exercise.categories.first { category in
            category.name == data.categoryName
        }
        self.category = existingCategory ?? Category(name: data.categoryName)
        Exercise.categories.append(self.category)
    }
    
    struct FormData {
        var name: String = ""
        var categoryName: String = ""
    }
    
    var data: FormData {
        FormData(name: name, categoryName: category.name)
    }
    
    mutating func update(from data: FormData) {
            name = data.name
            let existingCategory = Exercise.categories.first { category in
                category.name == data.categoryName
            }
            self.category = existingCategory ?? Category(name: data.categoryName)
            Exercise.categories.append(self.category)
    }
}

extension Exercise {
    static var categories: [Category] = []
}

extension Exercise {
    static let sampleCategories = [Category(name: "Pecs"), Category(name: "Back"), Category(name: "Lats"), Category(name: "Cardio")]
    static let sampleData = [
        Exercise(title: "Bench Press", category: sampleCategories[0]),
        Exercise(title: "Deadlift", category: sampleCategories[1]),
        Exercise(title: "Pull Up", category: sampleCategories[2]),
        Exercise(title: "Running", category: sampleCategories[3])
    ]
}
