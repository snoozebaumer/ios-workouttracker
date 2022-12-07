//
//  ExercisesStore.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 21.11.22.
//

import Foundation

class ExercisesService: ObservableObject {
    @Published var exercises: [Exercise] = []

    static func save(exercise: Exercise, httpMethod: String = "POST", id: UUID? = nil, completion: @escaping (_ isSuccess: Bool) -> ()) {
        guard let url = URL(string: "http://localhost:3000/exercise/" + (id?.uuidString ?? ""))
        else {
            return
        }
        let encodedData = try! JSONEncoder().encode(exercise)
        let jsonString = String(data: encodedData, encoding: .utf8)
        let postString = "exercise=" + jsonString!

        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        completion(false)
                        return
                    }

                    let httpResponse = response as! HTTPURLResponse
                    let isSuccess = (httpResponse.statusCode == 200)
                    completion(isSuccess)

                }
                .resume()
    }


    static func delete(id: UUID, completion: @escaping (_ didDeleteCategory: Bool) -> Void) {
        guard let url = URL(string: "http://localhost:3000/exercise/" + id.uuidString)
        else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }

                    if let data = data, data.isEmpty == false {
                        let didAlsoDeleteCategory: Bool = String(data: data, encoding: .utf8) == "true"
                        completion(didAlsoDeleteCategory)
                    }
                }
                .resume()
    }

    static func load() async throws -> [Exercise] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let exerciseList):
                    continuation.resume(returning: exerciseList)
                }
            }
        }
    }

    private static func load(completion: @escaping (Result<[Exercise], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/exercises/")
        else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error)
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        return
                    }

                    if let data = data, data.isEmpty == false {
                        do {
                            let exercises = try JSONDecoder().decode([Exercise].self, from: data)
                            completion(.success(exercises))
                        } catch {
                            completion(.failure(error))
                        }
                    }

                }
                .resume()
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
        Exercise(title: "Bench Press", category: sampleCategories[0], workouts: [Workout(sets: [60, 4])]),
        Exercise(title: "Deadlift", category: sampleCategories[1], sizeUnit: .lb, workouts: [Workout(sets: [200, 6])]),
        Exercise(title: "Pull Up", category: sampleCategories[2], workouts: [Workout(sets: [75, 12])]),
        Exercise(title: "Running", category: sampleCategories[3], sizeUnit: .km, lengthUnit: .min, workouts: [Workout(sets: [20, 160])])
    ]
    static let sampleData = ExercisesService(exercises: sampleExercises)
}
