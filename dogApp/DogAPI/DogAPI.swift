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
        case networkError
        case decodingError
        case invalidURL
        case unknownError

        var localizedDescription: String {
            switch self {
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

    func fetchDogList(completion: @escaping (Result<DogList, DogError>) -> Void) {
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
        print("URL: \(url)")
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
                print("String: \(string)")
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
            if let error = error {
                return completion(.failure(.networkError))
            }
            guard let data = data else {
                return completion(.failure(DogError.networkError))
            }
            completion(.success(data))
        }
        task.resume()
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

