//
//  AskMeViewModel.swift
//  AskMeWord
//
//  Created by Fatih OKSUZOGLU on 22.08.2023.
//

import Foundation

class AskMeViewModel: ObservableObject {
    @Published var wordViewData: WordViewData?
    @Published var error: NoDef?

    // Load data for a given word
    func loadData(for word: String) {
        // Construct the URL string using the API base URL and the provided word
        let urlString = "\(Configuration.apiBaseUrl)\(word)"

        // Create a URL if the URL string is valid
        if let url = URL(string: urlString) {
            // Fetch dynamic object from the URL with the expected response type of an array of Word objects
            fetchDynamicObject(from: url, responseType: [Word].self) { result in
                switch result {
                case let .success(words):
                    // If successful, populate the wordViewData with the first word's view data
                    self.wordViewData = WordViewData(word: words.first!)
                case let .failure(error):
                    // If there's an error, reset wordViewData and check for NoDef error
                    self.wordViewData = nil
                    if let noDefError = error as? NoDef {
                        self.error = noDefError
                    }
                }
            }
        }
    }

    // Get the stored WordViewData
    func getWordViewData() -> WordViewData? {
        return wordViewData
    }
}
