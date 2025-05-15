//
//  DogAPI.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-12.
//

import Foundation

class DogAPI {
    static let shared = DogAPI()
    enum DogError: Error {
        case failedToFetchDogList(error: Error)
        case networkError
        case decodingError
        case invalidURL
        case unknownError

        var localizedDescription: String {
            switch self {
            case .failedToFetchDogList(let error):
                return "Failed to fetch dog list: \(error.localizedDescription)"
            case .networkError:
                return "Network error occurred."
            case .decodingError:
                return "Failed to decode data."
            case .invalidURL:
                return "Invalid URL."
            case .unknownError:
                return "An unknown error occurred."
            }
        }
    }
    class DogList: Codable {
        var message: Dictionary<String, [String]>?
        var status: String
        enum CodingKeys: CodingKey {
            case message
            case status
        }
        init(message: Dictionary<String, [String]>?, status: String) {
            self.message = message
            self.status = status
        }
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            message = try container.decode(Dictionary<String, [String]>.self, forKey: .message)
            status = try container.decode(String.self, forKey: .status)
        }
    }
    private class RandomImage: Codable {
        var message: String?
        var status: String
        enum CodingKeys: CodingKey {
            case message
            case status
        }
        init(message: String?, status: String) {
            self.message = message
            self.status = status
        }
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            message = try container.decode(String.self, forKey: .message)
            status = try container.decode(String.self, forKey: .status)
        }
    }
    
    private func fetchDogList(completion: @escaping (Result<DogList, DogError>) -> Void) {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: urlString) else {
            return completion(.failure(DogError.invalidURL))
        }
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: config)
        session.configuration.timeoutIntervalForRequest = 10.0
        Task {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(DogError.networkError))
            }
            do {
                let dogList = try JSONDecoder().decode(DogList.self, from: data)
                return completion(.success(dogList))
            } catch {
                print("Error decoding JSON: \(error)")
                return completion(.failure(DogError.decodingError))
            }
        }
    }
    
    func fetchRandomImageURL(breed: String, completion: @escaping (Result<URL, DogError>) -> Void) {
        let urlString = "https://dog.ceo/api/breed/\(breed)/images/random"
        guard let url = URL(string: urlString) else {
            return completion(.failure(DogError.invalidURL))
        }
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: config)
        session.configuration.timeoutIntervalForRequest = 10.0
        Task {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(DogError.networkError))
            }
            do {
                let dogList = try JSONDecoder().decode(RandomImage.self, from: data)
                guard let string = dogList.message else {
                    return completion(.failure(DogError.decodingError))
                }
                guard let url = URL(string: string) else {
                    return completion(.failure(DogError.unknownError))
                }
                return completion(.success(url))
            } catch {
                print("Error decoding JSON: \(error)")
                return completion(.failure(DogError.decodingError))
            }
        }
    }
    
    func fetchDogImage(from url: URL, completion: @escaping (Result<Data, DogError>) -> Void) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: config)
        session.configuration.timeoutIntervalForRequest = 10.0
        let task = session.dataTask(with: url) { data, response, error in
            if let _ = error {
                return completion(.failure(.networkError))
            }
            guard let data = data else {
                return completion(.failure(DogError.networkError))
            }
            completion(.success(data))
        }
        task.resume()
    }

    func fetchSortedDogList(completion: @escaping (Result<[String], DogError>) -> Void) {
        DogAPI.shared.fetchDogList() { result in
            switch result {
            case .failure(let error):
                completion(.failure(.failedToFetchDogList(error: error)))
            case .success(let dogList):
                guard let message = dogList.message else {
                    return
                }
                let dogList = message.flatMap {
                    if $0.value.isEmpty {
                        return [$0.key]
                    }
                    let breedName = $0.key
                    let subBreed = $0.value.compactMap( { $0 })
                    return subBreed.map { "\(breedName) \($0)" }
                }.sorted()
                completion(.success(dogList))
            }
        }

    }
}

extension DogAPI.DogList: Hashable {
    static func == (lhs: DogAPI.DogList, rhs: DogAPI.DogList) -> Bool {
        return lhs.status == rhs.status && lhs.message == rhs.message
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(message)
        hasher.combine(status)
    }
}

