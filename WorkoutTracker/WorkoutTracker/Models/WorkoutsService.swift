//
//  WorkoutsService.swift
//  WorkoutTracker
//
//  Created by TIP on 02.12.22.
//

import Foundation

class WorkoutsService : ObservableObject {
    @Published var workouts: [Workout] = []
    
    
    static func save(workout: Workout, httpMethod: String = "POST", id: UUID? = nil ,completion:@escaping(_ isSuccess: Bool) -> ())  {
 
        guard let url =  URL(string:"http://localhost:3000/workout/" + (id?.uuidString ?? ""))
        else{
            return
        }
        
        let encodedData = try! JSONEncoder().encode(workout)
        let jsonString = String(data: encodedData, encoding: .utf8)
        let postString = "workout=" + jsonString!
        
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
