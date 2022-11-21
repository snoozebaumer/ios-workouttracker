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
    
    mutating func update(from data: FormData, completion:@escaping(_ isSuccess: Bool) -> ()) async {
        let existingCategory = Exercise.categories.first { category in
            category.name == data.categoryName
        }
        
        let category = existingCategory ?? Category(name: data.categoryName)
        let savingExercise: Exercise = Exercise(id: self.id, title: data.name, category: category)
        
        if (existingCategory == nil) {
            Exercise.categories.append(self.category)
        }
        let isSuccess = await fetchUpdateSuccess(savingExercise: savingExercise, id: self.id)
        if (isSuccess) {
            self.name = data.name
            self.category = category
        }
        completion(isSuccess)
        /*Exercise.save(exercise: savingExercise, httpMethod: "PUT", id: self.id) {
            isSuccess in
            if(isSuccess) {
                self = savingExercise
            }
            completion(isSuccess)
        }*/
    }
    
    func fetchUpdateSuccess(savingExercise: Exercise, id: UUID) async -> Bool {
        await withCheckedContinuation { continuation in
            Exercise.save(exercise: savingExercise, httpMethod: "PUT", id: id) { isSuccess in
                continuation.resume(returning: isSuccess)
            }
        }
    }
}

extension Exercise {
    static var categories: [Category] = []
}

extension Exercise {
    static func save(exercise: Exercise, httpMethod: String = "POST", id: UUID? = nil ,completion:@escaping(_ isSuccess: Bool) -> ())  {
        guard let url =  URL(string:"http://localhost:3000/exercise/" + (id?.uuidString ?? ""))
        else{
            return
        }
        
        let encodedData = try! JSONEncoder().encode(exercise)
        let jsonString = String(data: encodedData, encoding: .utf8)
        let postString = "exercise=" + jsonString!
        
        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let isSuccess = (httpResponse.statusCode == 200)
            completion(isSuccess)
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
