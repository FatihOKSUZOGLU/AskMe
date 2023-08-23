//
//  Fetch.swift
//  AskMeWord
//
//  Created by Fatih OKSUZOGLU on 19.08.2023.
//
import Combine
import Foundation

// Dinamik obje ile ilgili olası hata durumlarını temsil eden enum
enum DynamicObjectError: Error {
    case invalidURL // Geçersiz URL hatası
    case networkError(Error) // Ağ hatası
    case decodingError(Error) // Çözme (decode) hatası
}

func fetchDynamicObject<T: Decodable>(from url: URL, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    // URLSession kullanarak API isteği yapma
    URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data) // Gelen verinin sadece data kısmını al
        .tryMap { data -> T in
            do {
                // Önce T tipinde decode etmeyi dene
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                // T tipinde decode edemediyse, NoDef tipinde decode etmeyi dene
                if let noDef = try? JSONDecoder().decode(NoDef.self, from: data) {
                    throw noDef
                }
                throw error
            }
        }
        .receive(on: DispatchQueue.main) // Sonuçları ana kuyruğa al, UI güncellemesi için
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
        .store(in: &cancellables) // Cancellation işlemleri için kullanılan Set
}

// Combine işlemlerini takip etmek için kullanılan cancellables set'i
private var cancellables = Set<AnyCancellable>()
