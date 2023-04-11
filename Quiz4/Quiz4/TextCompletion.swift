//
//  TextCompletion.swift
//  Quiz4
//
//  Created by user234695 on 4/10/23.
//

import Foundation

struct TextCompletion {
    static func completeSentence(prompt: String, completion: @escaping (String?) -> Void) {
        let apiKey = "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"
        let urlString = "https://api.openai.com/v1/completions"
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        let parameters = [
            "model": "text-davinci-002",
            "prompt": prompt,
            "max_tokens": 50,
            "n": 1,
            "stop": "."
        ] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        guard let url = URL(string: urlString),
              let data = jsonData else {
            completion(nil)
            return
        }
        
        var responseText: String?
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let text = choices.first?["text"] as? String else {
                completion(nil)
                return
            }
            
            responseText = text
            completion(responseText)
        }
        task.resume()
    }
}
