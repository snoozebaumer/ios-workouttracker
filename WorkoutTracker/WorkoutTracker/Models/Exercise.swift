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
    static func save(exercise: Exercise) {
        guard let url =  URL(string:"http://localhost:3000/exercise")
        else{
            return
        }
        
        let encodedData = try! JSONEncoder().encode(exercise)
        let jsonString = String(data: encodedData, encoding: .utf8)
        let postString = "exercise=" + jsonString!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            print(response as Any)
            if let error = error {
                print(error)
                return
            }
            guard let data = data else{
                return
            }
            print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
            
        }.resume()
    }
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
