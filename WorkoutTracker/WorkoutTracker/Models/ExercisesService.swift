//
//  ExercisesStore.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 21.11.22.
//

import Foundation

class ExercisesService: ObservableObject {
    @Published var exercises: [Exercise] = []
    
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
    
    static func load(completion: @escaping(_ exercises: [Exercise]) -> ()) {
        // TODO: load from server, then call load in WorkoutTrackerApp with
        /* .task {
         do {
             store.scrums = try await ScrumStore.load()
         } catch {
             errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue")
         }
     } on Navigationview*/
    }
}


/// Sample Data Extension
extension ExercisesService {
    convenience init(exercises: [Exercise]) {
        self.init()
        self.exercises = exercises
    }
    private static let sampleCategories = [Category(name: "Pecs"), Category(name: "Back"), Category(name: "Lats"), Category(name: "Cardio")]
    private static let sampleExercises = [
        Exercise(title: "Bench Press", category: sampleCategories[0]),
        Exercise(title: "Deadlift", category: sampleCategories[1]),
        Exercise(title: "Pull Up", category: sampleCategories[2]),
        Exercise(title: "Running", category: sampleCategories[3])
    ]
    static let sampleData = ExercisesService(exercises: sampleExercises)
}
