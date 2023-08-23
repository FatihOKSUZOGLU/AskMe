import Foundation
import SwiftUI
import UIKit

class WordViewData: ObservableObject {
    @Published var word: Word
    @Published var meaningExpansion: [Bool]

    init(word: Word) {
        self.word = word
        meaningExpansion = Array(repeating: false, count: word.meanings.count)
    }
}

struct Word: Codable {
    var word: String
    var meanings: [Meaning]
}

struct Meaning: Codable {
    var partOfSpeech: String
    var definitions: [Definition]
}

struct Definition: Codable {
    var definition: String
    var example: String?
}

struct NoDef: Codable, Error {
    var title: String
    var message: String
    var resolution: String
}
