//
//  Fetch.swift
//  AskMeWord
//
//  Created by Fatih OKSUZOGLU on 19.08.2023.
//
import Combine
import Foundation

// Enum representing possible error cases related to dynamic objects
enum DynamicObjectError: Error {
    case invalidURL // Invalid URL error
    case networkError(Error) // Network error
    case decodingError(Error) // Decoding error
}

func fetchDynamicObject<T: Decodable>(from url: URL, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    // Making API request using URLSession
    URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data) // Extract only the data part of the incoming result
        .tryMap { data -> T in
            do {
                // Attempt to decode as type T
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                // If unable to decode as type T, attempt to decode as type NoDef
                if let noDef = try? JSONDecoder().decode(NoDef.self, from: data) {
                    throw noDef
                }
                throw error
            }
        }
        .receive(on: DispatchQueue.main) // Switch to the main queue for result handling, for UI updates
        .sink { completionResult in
            switch completionResult {
            case .finished:
                break
            case let .failure(error):
                completion(.failure(error))
            }
        } receiveValue: { response in
            completion(.success(response))
        }
        .store(in: &cancellables) // Set used for cancellation purposes
}

// Cancellables set used to keep track of Combine operations
private var cancellables = Set<AnyCancellable>()
