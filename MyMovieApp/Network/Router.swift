//
//  Router.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {    
    case popular(page: Int?)
    case nowPlaying(page: Int?)
    case topRated(page: Int?)
    case upcoming(page: Int?)
    case configuration
    
    var baseURL: URL? {
        return URL(string: "https://api.themoviedb.org/3/")
    }
    
    var path: String {
        switch self {
        case .popular:
            return "movie/popular"
        case .nowPlaying:
            return "movie/now_playing"
        case .topRated:
            return "movie/top_rated"
        case .upcoming:
            return "movie/upcoming"
        case .configuration:
            return "configuration"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: [String: Any]? {
        var params: Parameters = [:]
        switch self {
        case .popular(page: let page):
            if let page {
                params["page"] = page
            }
        case .nowPlaying(page: let page):
            if let page {
                params["page"] = page
            }
        case .topRated(page: let page):
            if let page {
                params["page"] = page
            }
        case .upcoming(page: let page):
            if let page {
                params["page"] = page
            }
        default:
            print("nothing")
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch method {
        default:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseURL else { throw URLError(.badURL)}
        var urlRequest = URLRequest(url: baseURL.appending(path: path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 10
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Bundle.main.object(forInfoDictionaryKey: "Api_Key")!)"
            
        ]
        
        do {
            let request = try encoding.encode(urlRequest, with: parameters)
            debugPrint("*** Request URL: ", request.url ?? "")
            return request
        }
        catch {
            debugPrint("*** Error \(error.localizedDescription)")
            throw error
        }
    }
}
