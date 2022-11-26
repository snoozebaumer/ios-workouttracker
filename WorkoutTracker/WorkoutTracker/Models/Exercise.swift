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
    }
    
    func fetchUpdateSuccess(savingExercise: Exercise, id: UUID) async -> Bool {
        await withCheckedContinuation { continuation in
            ExercisesService.save(exercise: savingExercise, httpMethod: "PUT", id: id) { isSuccess in
                continuation.resume(returning: isSuccess)
            }
        }
    }
}


extension Exercise {
    static var categories: [Category] = []
}



