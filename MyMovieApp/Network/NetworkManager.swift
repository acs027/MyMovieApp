//
//  NetworkManager.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
    func request<T: Decodable>(_ request: URLRequestConvertible, decodeTo type: T.Type, completion: @escaping (Result<T,NetworkError>) -> ())
}

final class NetworkManager: NetworkProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(_ request: URLRequestConvertible, decodeTo type: T.Type, completion: @escaping (Result<T,NetworkError>) -> ()) {
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(type.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(.decodingFailed))
                    debugPrint(error.localizedDescription)
                }
            case .failure(let error):
                let statusCode = response.response?.statusCode ?? 0
                completion(.failure(self.getError(for: statusCode)))
                debugPrint(error.localizedDescription)
            }
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case custom(String)
}

private extension NetworkManager {
    func getError(for statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .custom("Bad Request")
        case 401: return .custom("Unauthorized")
        case 403: return .custom("Forbidden")
        case 404: return .custom("Not Found")
        case 405: return .custom("Method Not Allowed")
        case 422: return .custom("Invalid parameters: Your request parameters are incorrect.")
        case 429: return .custom("Your request count (#) is over the allowed limit of (40).")
        case 500: return .custom("Failed")
        case 501: return .custom("Invalid service: this service does not exist.")
        case 503: return .custom("Service offline: This service is temporarily offline, try again later.")
        default:
            return .custom("Unknown error: \(statusCode)")
        }
    }
}

