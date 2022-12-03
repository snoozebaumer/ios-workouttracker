//
//  Set.swift
//  WorkoutTracker
//
//  Created by TIP on 18.11.22.
//

import Foundation

struct Workout: Equatable, Identifiable, Codable {
    
    let id: UUID
    var name: String
    var exerciseID: UUID
    var sets : [Set]

   
 
    
    init(id: UUID = UUID(), sets: [Float]) {
        self.id = id
        func convertDateFormatter(date: Date) -> String {
             let date = Date()
             let formatter = DateFormatter()
             formatter.dateFormat = "dd.MM.yyyy hh:mm" // change format as per needs
             let result = formatter.string(from: date)
             return result
           }
        self.name = convertDateFormatter(date: Date.now)
        //self.excercise = excercise
       /* self.strength = strenght
        self.metric = metric
        if(strenght){
            //display as 5 * x{metric}
            if(!metric&&strenght){
                //display as 5 * x{imperial}
            }
        }
        else{
            //display as 5km / x{min}
            if(!metric){
                //diplay as 5mi / x{min}
            }
        }*/
        self.exerciseID = UUID()
        self.sets = []
        self.sets.append(Set(howmuch: sets[0], howlong: sets[1]))
    
        
    }
    
    
}


extension Workout {
    init(id: UUID = UUID(), data: FormData) {
        self.id = id
        self.exerciseID = UUID()
        func convertDateFormatter(date: Date) -> String {
             let date = Date()
             let formatter = DateFormatter()
             formatter.dateFormat = "dd.MM.yyyy hh:mm" // change format as per needs
             let result = formatter.string(from: date)
             return result
           }
        self.name = convertDateFormatter(date: Date.now)
        self.sets = data.sets
        // TBD 
        //self.strength = true
        //self.metric = true
        //self.excercise = ""
        
    }
    
    struct Set: Identifiable, Codable, Hashable, Comparable {
        static func < (lhs: Workout.Set, rhs: Workout.Set) -> Bool {
            lhs.howmuch < rhs.howmuch
        }
        
        var id: UUID
        var howmuch: Float
        var howlong: Float
        
        init(id: UUID = UUID(), howmuch: Float, howlong: Float) {
            self.id = id
            self.howmuch = howmuch
            self.howlong = howlong
            
        }
        
        
        mutating func updateSets(changeHowmuch: Float, changeHowlong: Float) {
            howmuch = changeHowmuch
            howlong = changeHowlong
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
    
        Workout(sets:[4,2])
        
        ]
    
    
}
    

