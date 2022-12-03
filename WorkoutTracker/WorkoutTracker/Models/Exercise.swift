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
    var workouts: [Workout] = []
    var sizeUnit: SizeUnit = .kg
    var lengthUnit: LengthUnit = .reps
  
 
    
    init(id: UUID = UUID(), title: String, category: Category, sizeUnit: SizeUnit = .kg, lengthUnit: LengthUnit = .reps, workouts: [Workout] = []) {
        self.id = id
        self.name = title
        self.category = category
        self.sizeUnit = sizeUnit
        self.lengthUnit = lengthUnit
        self.workouts = workouts
    }
    
    //get the highest amount of whatever unit to display in ExerciseListItemView
    func getStrongestSetString() -> String {
        if(self.workouts.count == 0) {
            return ""
        }
        
        let maxes: [Float] = self.workouts.map { set in
            guard let max = set.sets.max()?.howmuch
            else {
                return 0
            }
            return max
        }
        
        if(maxes.max() == 0) {
            return ""
        }
        return NSString(format: "%.0f", maxes.max()!) as String
    }
    

    mutating func updateWorkout(workout: Workout){
        workouts.append(workout)
    }
    
    mutating func changeWorkout(originalWorkout: Workout, changedWorkout: Workout){
        if let index = workouts.firstIndex(of: originalWorkout) {
            workouts.remove(at: index)
            workouts.insert(changedWorkout, at: index)
        }
    }
    
 
}

extension Exercise {
    
    struct changeSetData {
        var eSet : [Workout] = []

    }
    
    var changesetdata: changeSetData {
        changeSetData(eSet: workouts)
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
        self.sizeUnit = data.sizeUnit
        self.lengthUnit = data.lengthUnit
    }
    
    struct FormData {
        var name: String = ""
        var categoryName: String = ""
        var sizeUnit: SizeUnit = .kg
        var lengthUnit: LengthUnit = .reps
    }
    
    var data: FormData {
        FormData(name: name, categoryName: category.name, sizeUnit: sizeUnit, lengthUnit: lengthUnit)
    }
    
    mutating func update(from data: FormData, completion:@escaping(_ isSuccess: Bool) -> ()) async {
        let existingCategory = Exercise.categories.first { category in
            category.name == data.categoryName
        }
        
        let category = existingCategory ?? Category(name: data.categoryName)
        let savingExercise: Exercise = Exercise(id: self.id, title: data.name, category: category,sizeUnit: data.sizeUnit, lengthUnit: data.lengthUnit, workouts: self.workouts)
        
        if (existingCategory == nil) {
            Exercise.categories.append(self.category)
        }
        let isSuccess = await fetchUpdateSuccess(savingExercise: savingExercise, id: self.id)
        if (isSuccess) {
            self.name = data.name
            self.category = category
            self.sizeUnit = data.sizeUnit
            self.lengthUnit = data.lengthUnit
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



