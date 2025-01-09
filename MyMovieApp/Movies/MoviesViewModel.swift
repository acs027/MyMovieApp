//
//  MoviesViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import Foundation
import CoreData

final class MoviesViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isDetailsShowing = false
    
    private(set) var tappedMovie: CDMovie?
    private var service = MoviesService()
    private var page = 1
    private var imageConfiguration: ImageConfiguration?
    private var context = PersistenceController.shared.container.viewContext
    
    var tappedMovieId: Int {
        return Int(tappedMovie?.id ?? 0)
    }
    
    init() {
        imageConfiguration = MockDataProvider().imageConfiguration()
        #if DEBUG
            _ = MockDataProvider().popularMovies().map({ movie in
                let popularMovie = CDMovie(from: movie, context: context)
                let coinflip = Int.random(in: 0...2)
                if coinflip == 0 {
                    popularMovie.isPopular = true
                } else if coinflip == 1 {
                    popularMovie.isNowPlaying = true
                } else {
                    popularMovie.isUpcoming = true
                }
            })
            PersistenceController.shared.save()
        #endif
    }
    
    
    func fetchPopularMovies() async {
        #if DEBUG
        return
        #endif
        service.fetchPopularMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
                _ = movieResponse.results.map {
                    let cdMovie = CDMovie(from: $0, context: self.context)
                    cdMovie.isPopular = true
                    print(cdMovie.title ?? "acs")
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
    
    func fetchUpcomingMovies() async {
        #if DEBUG
        return
        #endif
        service.fetchUpcomingMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
                _ = movieResponse.results.map {
                    let cdMovie = CDMovie(from: $0, context: self.context)
                    cdMovie.isUpcoming = true
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
    
    func fetchNowPlayingMovies() async {
        #if DEBUG
        return
        #endif
        service.fetchNowPlayingMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let movieResponse):
                _ = movieResponse.results.map {
                    let cdMovie = CDMovie(from: $0, context: self.context)
                    cdMovie.isNowPlaying = true
                    
                }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    debugPrint("\(error.localizedDescription)")
                
            }
        }
    }
    
    func fetchConfiguration() async {
        service.fetchConfiguration { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let configurationResponse):
                imageConfiguration = configurationResponse.images
            case .failure(let error):
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
    
    func posterUrl(for movie: CDMovie) -> URL? {
        guard let posterPath = movie.posterPath else { return nil }
        guard let baseURL = imageConfiguration?.secureBaseURL else { return nil }
        guard let posterSize = imageConfiguration?.posterSizes.first else { return nil }
        guard let url = URL(string: baseURL+posterSize+posterPath) else { return nil }
        return url
    }
    
    func showMovieDetails(of movie: CDMovie) {
        self.tappedMovie = movie
        self.isDetailsShowing = true
    }
    
    func save() {
        PersistenceController.shared.save()
    }
}


