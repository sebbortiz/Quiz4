//
//  SentimentAnalysis.swift
//  Quiz4
//
//  Created by user234695 on 4/10/23.
//

import Foundation

let apiKey = "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"

func getSentiment(sentence: String, completion: @escaping (String?, Error?) -> Void) {
    let url = URL(string: "https://api.openai.com/v1/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let parameters: [String: Any] = [
        "model": "text-davinci-002",
        "prompt": "Determine the sentiment of this text: \"\(sentence)\". Is it positive, negative, or neutral?",
        "temperature": 0.5,
        "max_tokens": 10,
        "n": 1
    ]

    let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])

    request.httpBody = postData

    let session = URLSession.shared

    let task = session.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }

        let result = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        if let error = result?["error"] as? String {
            completion(nil, NSError(domain: "OpenAIError", code: 1, userInfo: [NSLocalizedDescriptionKey: error]))
            return
        }

        if let choices = result?["choices"] as? [[String: Any]], let sentiment = choices[0]["text"] as? String {
            completion(sentiment, nil)
        } else {
            completion(nil, NSError(domain: "OpenAIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not determine sentiment"]))
        }
    }

    task.resume()
}


