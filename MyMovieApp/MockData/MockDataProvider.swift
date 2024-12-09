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
                print("Error occured while decoding Data")
                return []
            }
        } else {
            print("Error occured while getting url")
            return []
        }
    }
    
    func imageConfiguration() -> ImageConfiguration? {
        if let url = Bundle.main.url(forResource: "configurationResponse", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(ConfigurationResponse.self, from: data)
                return decoded.images
            } catch {
                print("Error occured while decoding ImageConfiguration Data")
                return nil
            }
        } else {
            print("Error occured while getting url")
            return nil
        }
    }
}
