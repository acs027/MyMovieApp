//
//  MockData.swift
//  MyMovieApp
//
//  Created by ali cihan on 4.12.2024.
//

import Foundation

struct MockDataProvider {
    func popularMovies() -> [Movie] {
        if let url = Bundle.main.url(forResource: "popularMoviesResponse", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                return decoded.results
            } catch {
                debugPrint("Error occured while decoding Data")
                return []
            }
        } else {
            debugPrint("Error occured while getting url")
            return []
        }
    }
    
    func movieDetails() -> MovieDetails? {
        if let url = Bundle.main.url(forResource: "movieDetailsResponse", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(MovieDetails.self, from: data)
                return decoded
            } catch {
                debugPrint("Error occured while decoding Data")
                return nil
            }
        } else {
            debugPrint("Error occured while getting url")
            return nil
        }
    }
    
    func imageConfiguration() -> ImageConfiguration? {
        if let url = Bundle.main.url(forResource: "configurationResponse", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(ConfigurationResponse.self, from: data)
                return decoded.images
            } catch {
                debugPrint("Error occured while decoding ImageConfiguration Data")
                return nil
            }
        } else {
            debugPrint("Error occured while getting url")
            return nil
        }
    }
}
