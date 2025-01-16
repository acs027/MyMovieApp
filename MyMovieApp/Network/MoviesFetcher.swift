//
//  MoviesFetcher.swift
//  MyMovieApp
//
//  Created by ali cihan on 15.01.2025.
//

import Foundation
import CoreData

final class MoviesFetcher {
    private var service: MoviesServiceProtocol
    private var context: NSManagedObjectContext

    init(service: MoviesServiceProtocol = MoviesService(), context: NSManagedObjectContext) {
        self.service = service
        self.context = context
    }

    func fetchMovies(ofType category: MovieCategory, page: Int = 1, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let fetchFunction: (Int?, @escaping (Result<MovieResponse, NetworkError>) -> Void) -> Void

        // Match the fetchFunction to the appropriate service method based on category
        switch category {
        case .popular:
            fetchFunction = service.fetchPopularMovies
        case .upcoming:
            fetchFunction = service.fetchUpcomingMovies
        case .nowPlaying:
            fetchFunction = service.fetchNowPlayingMovies
//        case .topRated:
//            fetchFunction = service.fetchTopRatedMovies
        }

        fetchFunction(page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
                // Map movies to Core Data entities
                movieResponse.results.forEach { movie in
                    let cdMovie = CDMovie(from: movie, context: self.context)
                    cdMovie.setFlag(for: category)
                }
                PersistenceController.shared.save()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension CDMovie {
    func setFlag(for category: MovieCategory) {
        switch category {
        case .popular:
            self.isPopular = true
        case .upcoming:
            self.isUpcoming = true
        case .nowPlaying:
            self.isNowPlaying = true
//        case .topRated:
            // Add a property like `isTopRated` in `CDMovie` if required
        }
    }
}


