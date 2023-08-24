//
//  AskMeView.swift
//  AskMeWord
//
//  Created by Fatih OKSUZOGLU on 22.08.2023.
//

import SwiftUI

struct AskMeView: View {
    @State private var searchWord = ""
    @StateObject private var viewModel = AskMeViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("word?", text: $searchWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()

                    Button("Search") {
                        viewModel.loadData(for: searchWord)
                    }
                    .padding(10)
                    .foregroundColor(Color.white)
                    .background(Color.blue.opacity(0.9))
                    .cornerRadius(20)

                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.blue.opacity(0.5))

                Spacer()

                if let responseWord = viewModel.getWordViewData() {
                    ScrollView {
                        WordView(wordViewData: responseWord)
                            .listRowInsets(EdgeInsets())
                    }
                } else if let noDefWord = viewModel.error {
                    ErrorView(error: noDefWord)
                }
            }
            .background(Color.gray.opacity(0.4))
        }
    }
}

struct WordView: View {
    @ObservedObject var wordViewData: WordViewData

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Text("Word:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(wordViewData.word.word)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            ForEach(wordViewData.word.meanings.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 4) {
                    Button(action: {
                        self.wordViewData.meaningExpansion[index].toggle()
                    }) {
                        HStack {
                            Text("Part of Speech:")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("\(wordViewData.word.meanings[index].partOfSpeech)")
                                .font(.subheadline)
                                .foregroundColor(.blue)

                            Spacer()
                            Image(systemName: self.wordViewData.meaningExpansion[index] ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .foregroundColor(.black)
                        }
                        .padding(10)
                    }
                    if self.wordViewData.meaningExpansion[index] {
                        ForEach(wordViewData.word.meanings[index].definitions.indices, id: \.self) { definitionIndex in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Definition:")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("\(wordViewData.word.meanings[index].definitions[definitionIndex].definition)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                if let example = wordViewData.word.meanings[index].definitions[definitionIndex].example {
                                    Text("Example:")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text("\(example)")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(5)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding(5)
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(5)
    }
}

struct ErrorView: View {
    var error: NoDef

    var body: some View {
        VStack {
            Text(error.title)
                .font(.title)
                .foregroundColor(.red)
                .padding(.bottom, 10)

            Text(error.message)
                .foregroundColor(.black)
                .padding(.bottom, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        Spacer()
    }
}

struct AskMeView_Previews: PreviewProvider {
    static var previews: some View {
        AskMeView()
    }
}
