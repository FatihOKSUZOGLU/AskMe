//
//  ContentView.swift
//  AskMeWord
//
//  Created by Fatih OKSUZOGLU on 22.08.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    Image("homeScreen")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)

                    Spacer()
                    HStack(spacing: 20) {
                        NavigationLink(destination: AskMeView()) {
                            ContentViewButton(title: "ASK ME")
                                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.width / 2)
                        }
                        NavigationLink(destination: Rand10View()) {
                            ContentViewButton(title: "Random 10 Word")
                                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.width / 2)
                        }
                    }
                    NavigationLink(destination: TranslateView()) {
                        ContentViewButton(title: "Translate")
                            .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.width / 2)
                    }
                }
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                .padding(10)
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}

struct ContentViewButton: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .cornerRadius(30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
