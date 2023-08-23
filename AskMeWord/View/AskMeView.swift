import SwiftUI

// struct AskMeView: View {
//    @State private var searchWord = ""
//    @State private var controller = AskMeController()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    TextField("word?", text: $searchWord)
//                        .padding()
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .autocapitalization(.none)
//
//                    Button("Search") {
//                        controller.loadData(for: searchWord)
//                    }
//                    .padding()
//                }
//                .padding(.horizontal)
//                .background(Color.gray)
//
//                Spacer()
//
//                if let responseWord = controller.getWordViewData() {
//                    ScrollView {
//                        WordView(wordViewData: responseWord)
//                            .listRowInsets(EdgeInsets())
//                    }
//                } else if let noDefWord = controller.getError() {
//                    ErrorView(error: noDefWord as! NoDef)
//                } else {
//                    Text("Not found!")
//                        .foregroundColor(.red)
//                        .padding(.top, 10)
//                }
//            }
//            .background(Color.gray)
//        }
//    }
// }
//
// struct WordView: View {
//    @ObservedObject var wordViewData: WordViewData
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 10) {
//            HStack {
//                Text("Word:")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                Text("\(wordViewData.word.word)")
//                    .font(.headline)
//                    .foregroundColor(.blue)
//            }
//
//            ForEach(wordViewData.word.meanings.indices, id: \.self) { index in
//                VStack(alignment: .leading, spacing: 4) {
//                    Button(action: {
//                        self.wordViewData.meaningExpansion[index].toggle()
//                    }) {
//                        HStack {
//                            Text("Part of Speech:")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            Text("\(wordViewData.word.meanings[index].partOfSpeech)")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//
//                            Spacer()
//                            Image(systemName: self.wordViewData.meaningExpansion[index] ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
//                                .foregroundColor(.white)
//                        }
//                    }
//                    if self.wordViewData.meaningExpansion[index] {
//                        ForEach(wordViewData.word.meanings[index].definitions.indices, id: \.self) { definitionIndex in
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Definition:")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                Text("\(wordViewData.word.meanings[index].definitions[definitionIndex].definition)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.green)
//                                if let example = wordViewData.word.meanings[index].definitions[definitionIndex].example {
//                                    Text("Example:")
//                                        .font(.headline)
//                                        .foregroundColor(.white)
//                                    Text("\(example)")
//                                        .font(.subheadline)
//                                        .foregroundColor(.purple)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//    }
// }
//
// struct ErrorView: View {
//    var error: NoDef
//
//    var body: some View {
//        VStack {
//            Text(error.title)
//                .font(.title)
//                .foregroundColor(.red)
//                .padding(.bottom, 10)
//
//            Text(error.message)
//                .foregroundColor(.black)
//                .padding(.bottom, 10)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
//        Spacer()
//    }
// }

struct AskMeView: View {
    @State private var searchWord = ""
    @State private var wordViewData: WordViewData?
    @State private var noDef: NoDef?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("word?", text: $searchWord)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    Button("Search") {
                        loadData()
                    }
                    .padding()
                }
                .padding(.horizontal)
                .background(Color.gray)

                Spacer()

                if let responseWord = wordViewData {
                    ScrollView {
                        WordView(wordViewData: responseWord)
                            .listRowInsets(EdgeInsets())
                    }
                } else if let noDefWord = noDef {
                    NoDefView(noDef: noDefWord)
                } else {
                    Text("Not found!")
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .background(Color.gray)
        }
    }

    func loadData() {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchWord)"
        if let url = URL(string: urlString) {
            fetchDynamicObject(from: url, responseType: [Word].self) { result in
                switch result {
                case let .success(word):
                    self.wordViewData = WordViewData(word: word.first!)
                    print("success")
                // Burada gelen API hatasını ele alabilirsiniz
                case let .failure(error):
                    print("fail")
                    self.wordViewData = nil
                    if let noDefError = error as? NoDef {
                        self.noDef = noDefError
                        print("noDef getted")
                    }
                }
            }
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
                                .foregroundColor(.white)
                            Text("\(wordViewData.word.meanings[index].partOfSpeech)")
                                .font(.subheadline)
                                .foregroundColor(.blue)

                            Spacer()
                            Image(systemName: self.wordViewData.meaningExpansion[index] ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                    if self.wordViewData.meaningExpansion[index] {
                        ForEach(wordViewData.word.meanings[index].definitions.indices, id: \.self) { definitionIndex in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Definition:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(wordViewData.word.meanings[index].definitions[definitionIndex].definition)")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                if let example = wordViewData.word.meanings[index].definitions[definitionIndex].example {
                                    Text("Example:")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("\(example)")
                                        .font(.subheadline)
                                        .foregroundColor(.purple)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct NoDefView: View {
    var noDef: NoDef
    var body: some View {
        VStack {
            Text(noDef.title)
                .font(.title)
                .foregroundColor(.red)
                .padding(.bottom, 10)

            Text(noDef.message)
                .foregroundColor(.black)
                .padding(.bottom, 10)

            Text(noDef.resolution)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct AskMeView_Previews: PreviewProvider {
    static var previews: some View {
        AskMeView()
    }
}
