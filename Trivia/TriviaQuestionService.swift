//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Kaila Aquino on 7/8/25.
//

import Foundation

class TriviaQuestionService {
    static func fetchQuestions(completion: @escaping ([TriviaQuestion]) -> Void) {
        
        guard let url = URL(string: "https://opentdb.com/api.php?amount=6&difficulty=easy") else {
            print("Invalid URL")
            completion([])
            return
        }
        
        // create a data task and pass in the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response object")
                completion([])
                return
            }
            
            guard let data = data, httpResponse.statusCode == 200 else {
                print("Unexpected status code: \(httpResponse.statusCode)")
                completion([])
                return
            }
            
            do {
                // decode json to swift and format into TriviaAPIRes format
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(TriviaAPIResponse.self, from: data)
                let questions = apiResponse.results
                
                // send the results back to main thread
                DispatchQueue.main.async {
                    completion(questions)
                }
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw response:", jsonString)
                }
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        
        task.resume()
    }
}
