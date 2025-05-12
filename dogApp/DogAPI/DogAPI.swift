//
//  DogAPI.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-12.
//

import Foundation

class DogAPI {
    static let shared = DogAPI()
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
    class RandomImage: Codable {
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
            message = try container.decodeIfPresent(String.self, forKey: .message)
            status = try container.decode(String.self, forKey: .status)
        }
    }
    func fetchDogList(completion: @escaping (Result<DogList, Error>) -> Void) {
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

    func fetchRandomImage(breed: String, completion: @escaping (Result<URL, Error>) -> Void) {
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
                guard let message = dogList.message else {
                    return completion(.failure(DogError.decodingError))
                }
                let string = String(describing: message.first)
                guard let url = URL(string: string) else {
                    return completion(.failure(DogError.unknownError))
                }
                guard dogList.status != "success" else {
                    return completion(.failure(DogError.unknownError))
                }
                return completion(.success(url))
            } catch {
                print("Error decoding JSON: \(error)")
                return completion(.failure(DogError.decodingError))
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

