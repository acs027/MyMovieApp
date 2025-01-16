//
//  SearchViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 13.01.2025.
//

import Foundation


final class SearchViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    
    var errorMessage = ""
    
    var service = MoviesService()
    
    init() {
        #if DEBUG
        movies = MockDataProvider().popularMovies()
        #endif
    }
    
    func fetchMovies(query: String) async {
        service.fetchMovies(query: query) { [weak self] result in
            print("acs")
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
                print("success")
                movies = movieResponse.results
            case .failure(let error):
                print("errror")
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
}
