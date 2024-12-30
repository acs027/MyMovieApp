//
//  MovieDetailsViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 25.12.2024.
//

import Foundation

class MovieDetailsViewModel: ObservableObject {
    @Published var isDetailsLoading = true
    @Published var movieDetails: MovieDetails?
    var errorMessage = ""
    let id: Int
    private var detailsService: MovieDetailsService
    private var imageConfiguration: ImageConfiguration?
    
    init(id: Int) {
        detailsService = MovieDetailsService()
        self.id = id
        imageConfiguration = MockDataProvider().imageConfiguration()
        #if DEBUG
        self.isDetailsLoading = false
        self.movieDetails = MockDataProvider().movieDetails()
        #endif
    }
    
    func fetchMovieDetails() async {
        DispatchQueue.main.async {
            self.isDetailsLoading = true
        }
        detailsService.fetchMovieDetails(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieDetails):
                self.movieDetails = movieDetails
                isDetailsLoading = false
            case .failure(let error):
                isDetailsLoading = false
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
    
    func getBackdropURL() -> URL? {
        guard let posterURL = movieDetails?.backdropPath else { return nil }
        guard let baseURL = imageConfiguration?.secureBaseURL else { return nil }
        guard let posterSize = imageConfiguration?.posterSizes.last else { return nil }
        let imageURL = URL(string: baseURL+posterSize+posterURL)
        print(imageURL ?? "invalid url")
        return imageURL
    }
}
