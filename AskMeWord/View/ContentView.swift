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
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    NavigationLink(destination: AskMeView()) {
                        ContentViewButton(title: "ASK ME")
                    }
                    NavigationLink(destination: App2()) {
                        ContentViewButton(title: "App2")
                    }
                    // Diğer butonlar
                }

                HStack(spacing: 20) {
                    NavigationLink(destination: App2()) {
                        ContentViewButton(title: "App3")
                    }
                    NavigationLink(destination: App2()) {
                        ContentViewButton(title: "App4")
                    }
                    // Diğer butonlar
                }

                HStack(spacing: 20) {
                    NavigationLink(destination: App2()) {
                        ContentViewButton(title: "App5")
                    }
                    NavigationLink(destination: App2()) {
                        ContentViewButton(title: "App6")
                    }
                    // Diğer butonlar
                }
            }
            .padding()
            .navigationBarTitle("Main Screen", displayMode: .inline) // Başlık metni ve displayMode
            .font(.largeTitle)
            .background(Color.gray)
        }
        .background(Color.gray)
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
            .background(Color.orange
            )
            .cornerRadius(30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
