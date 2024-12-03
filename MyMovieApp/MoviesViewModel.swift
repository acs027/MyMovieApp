//
//  MoviesViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import Foundation

final class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var service = MoviesService()
    private var page = 1

    func fetchPopularMovies() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        service.fetchPopularMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
                movies = movieResponse.results
                isLoading = false
//                page += 1
            case .failure(let error):
                isLoading = false
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
//                page = 1
            }
        }
    }
    
    func fetchUpcomingMovies() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        service.fetchUpcomingMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
                movies = movieResponse.results
                isLoading = false
//                page += 1
            case .failure(let error):
                isLoading = false
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
//                page = 1
            }
        }
    }
}


