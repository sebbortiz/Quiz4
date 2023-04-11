//
//  OpenAIImageGenerator.swift
//  Quiz4
//
//  Created by user234695 on 4/10/23.
//

// OpenAI.swift
import UIKit
import Foundation

struct ImageGeneration {
    static let apiKey = "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"
    
    static func generateImage(prompt: String, n: Int, size:String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://api.openai.com/v1/images/generations"
        let params = [            "prompt": prompt,            "n": 1,            "size": "1024x1024",            "response_format": "url"        ] as [String : Any]
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "com.example.OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            let error = NSError(domain: "com.example.OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])
            completion(.failure(error))
            return
        }
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.example.OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(error))
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let dataArray = json["data"] as? [[String: Any]],
               let url = dataArray.first?["url"] as? String,
               let imageUrl = URL(string: url),
               let imageData = try? Data(contentsOf: imageUrl) {
                completion(.success(imageData))
            } else {
                let error = NSError(domain: "com.example.OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}







