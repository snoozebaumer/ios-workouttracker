//
//  Set.swift
//  WorkoutTracker
//
//  Created by TIP on 18.11.22.
//

import Foundation

struct Set: Identifiable, Codable {
    let id: UUID
    var name: String
    //var excercise: Exercise
    //var excercise: String
    var sets : [Sets]
   // var strength : Bool
   // var metric : Bool
   
 
    
    init(id: UUID = UUID(), /*excercise: Exercise*/ /*excercise:String, strenght: Bool, metric: Bool,*/ sets: [Float]) {
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
        
        self.sets = []
        self.sets.append(Sets(howmuch: sets[0], howlong: sets[1]))
    
        
    }
    
}


extension Set {
    init(id: UUID = UUID(), data: FormData) {
        self.id = id
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
    
    struct Sets: Identifiable, Codable, Hashable {
        var id: UUID
        var howmuch: Float
        var howlong: Float
        
        init(id: UUID = UUID(), howmuch: Float, howlong: Float) {
            self.id = id
            self.howmuch = howmuch
            self.howlong = howlong
            
        }
    }
    

    struct FormData {
        var sets: [Sets] = []
    }
    
    var data: FormData {
        FormData(sets: sets)
    }
    
    mutating func update(from data: FormData) {
            sets = data.sets
            
    }
}



extension Set {
    static let sampleData: [Set] =
    [
        Set(/*excercise: "Test", strenght: true, metric: true, */sets:[4,2]),
       
        
    ]
}
