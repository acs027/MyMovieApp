//
//  MoviesFetcher.swift
//  MyMovieApp
//
//  Created by ali cihan on 15.01.2025.
//

import Foundation
import CoreData

final class MovieFetcher {
    private var service: MovieServiceProtocol
    private var context: NSManagedObjectContext
    private let fetchQueue = DispatchQueue(label: "com.acs027.moviesFetcherQueue")
    
    init(service: MovieServiceProtocol = MovieService(), context: NSManagedObjectContext) {
        self.service = service
        self.context = context
    }
    
    func fetchMovies(ofType category: MovieCategory, page: Int = 1, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        fetchQueue.async {
            let fetchFunction: (Int?, @escaping (Result<MovieResponse, NetworkError>) -> Void) -> Void
            switch category {
            case .popular:
                fetchFunction = self.service.fetchPopularMovies
            case .upcoming:
                fetchFunction = self.service.fetchUpcomingMovies
            case .nowPlaying:
                fetchFunction = self.service.fetchNowPlayingMovies
                //        case .topRated:
                //            fetchFunction = service.fetchTopRatedMovies
            }
            debugPrint("API called")
            
            fetchFunction(page) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let movieResponse):
                    debugPrint("Object count from API: \(movieResponse.results.count)")
                    movieResponse.results.forEach { movie in
                        let cdMovie = CDMovie(from: movie, context: self.context)
                        cdMovie.setFlag(for: category)
                        cdMovie.setDate(for: category)
                    }
                    PersistenceController.shared.save()
                    UserDefaults.standard.set(page, forKey: category.pageKey)
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
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
        }
    }
    
    func setDate(for category: MovieCategory) {
        switch category {
        case .popular:
            self.popularDate = Date()
        case .upcoming:
            self.upcomingDate = Date()
        case .nowPlaying:
            self.nowPlayingDate = Date()
        }
    }
}


