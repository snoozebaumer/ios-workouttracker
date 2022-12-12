//
//  Set.swift
//  WorkoutTracker
//
//  Created by TIP on 18.11.22.
//

import Foundation

struct Workout: Equatable, Identifiable, Codable {

    let id: UUID
    var name: Date
    var exerciseID: UUID
    var sets: [Set] = []


    init(id: UUID = UUID(), sets: [Float] = []) {
        self.id = id
        self.name = Date()
        self.exerciseID = UUID()
        self.sets.append(Set(howmuch: sets[0], howlong: sets[1]))
    }
}


extension Workout {
    init(id: UUID = UUID(), data: FormData, exerciseID: UUID = UUID()) {
        self.id = id
        self.exerciseID = exerciseID
        self.name = Date()
        self.sets = data.sets
        sets.indices.forEach{sets[$0].updateWorkoutID(changeWorkoutID: self.id)}
        
    }
    

    struct Set: Identifiable, Codable, Hashable, Comparable {
        static func <(lhs: Workout.Set, rhs: Workout.Set) -> Bool {
            lhs.howmuch < rhs.howmuch
        }

        var id: UUID
        var howmuch: Float
        var howlong: Float
        var workoutID: UUID = UUID()

        init(id: UUID = UUID(), howmuch: Float, howlong: Float) {
            self.id = id
            self.howmuch = howmuch
            self.howlong = howlong
           
        }


        mutating func updateSets(changeHowmuch: Float, changeHowlong: Float) {
            howmuch = changeHowmuch
            howlong = changeHowlong
        }
        
        mutating func updateWorkoutID(changeWorkoutID: UUID) {
            workoutID = changeWorkoutID
        }
  
    }
    
    

    struct FormData {
        var sets: [Set] = []
       
    }
    

    var data: FormData {
        FormData(sets: sets)
    }

    mutating func updateExerciseID(from data: UUID) {
        self.exerciseID = data
    }
    
}


extension Workout {
    static let sampleData: [Workout] = [
        Workout(sets: [4, 2])
    ]
}
    

