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

    func loadData(for word: String) {
        let urlString = "\(Configuration.apiBaseUrl)\(word)"
        if let url = URL(string: urlString) {
            fetchDynamicObject(from: url, responseType: [Word].self) { result in
                switch result {
                case let .success(word):
                    self.wordViewData = WordViewData(word: word.first!)
                    print("success")
                case let .failure(error):
                    print("fail")
                    self.wordViewData = nil
                    if let noDefError = error as? NoDef {
                        self.error = noDefError
                        print("noDef getted")
                    }
                }
            }
        }
    }
}
