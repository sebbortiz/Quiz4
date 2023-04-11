//
//  ContentView.swift
//  Quiz4
//
//  Created by user234695 on 4/9/23.
//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
import SwiftUI
import UIKit

struct ContentView: View {
    @State private var text = ""
    @State private var image: Image?
    @State private var completion: String?
    @State private var sentiment: String?
    
    var body: some View {
ScrollView {
            Text("OpenAI Demo")
                .font(.largeTitle)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Enter text:")
                TextEditor(text: $text)
                    .frame(height: 150)
            }
            .padding()
            
            Button(action: generateImage) {
                Text("Generate Image")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            
            Button(action: completeSentence) {
                Text("Complete Sentence")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            if let completion = completion {
                Text(completion)
                    .padding()
            }
            
            Button(action: fetchSentiment) {
                Text("Get Sentiment")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            if let sentiment = sentiment {
                Text("Sentiment: \(sentiment)")
                .padding()}
            Spacer()
        }
    }
    
    func generateImage() {
        ImageGeneration.generateImage(prompt: text, n:1, size:"1024x1024") { result in
            switch result {
            case .success(let data):
                // Print out the response data received from the API
                print(String(data: data, encoding: .utf8) ?? "Invalid response data")
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: image)
                    }
                } else {
                    print("Error: Unable to convert image data to UIImage")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func completeSentence() {
        TextCompletion.completeSentence(prompt: text) { completion in
            DispatchQueue.main.async {
                self.completion = completion ?? "No completion found"
            }
        }
    }
    
    func fetchSentiment() {
        getSentiment(sentence: text) { sentiment, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let sentiment = sentiment {
                DispatchQueue.main.async {
                    self.sentiment = sentiment
                }
            }
        }
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

