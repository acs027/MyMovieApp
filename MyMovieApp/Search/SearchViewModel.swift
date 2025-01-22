//
//  SearchViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 13.01.2025.
//

import Foundation


final class SearchViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var queryString: String = ""
    @Published var errorMessage = ""
    var service = MovieService()
        
    func fetchMovies() async {
        service.fetchMovies(query: queryString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
                movies = movieResponse.results
            case .failure(let error):
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
    
    func checkQueryString() -> Bool {
        var isValid = true
        if queryString.isEmpty {
           isValid = false
           errorMessage = "Search text cannot be empty."
       } else if queryString.count < 3 {
           isValid = false
           errorMessage = "Search text must be at least 3 characters long."
       } else if !queryString.trimmingCharacters(in: .whitespaces).isEmpty {
           isValid = true
       } else {
           isValid = false
           errorMessage = "Search text cannot contain only whitespace."
       }
        return isValid
    }
}
