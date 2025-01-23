//
//  VerticalMoviesListViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 14.01.2025.
//

import Foundation
import CoreData

class MovieListViewModel: ObservableObject {
    @Published var movies: [CDMovie] = []
    @Published var tappedMovieId: Int = 0
    @Published var isDetailsShowing = false
    var errorMessage = ""
    private var dataOffset: Int {
        movies.count
    }
    private let context: NSManagedObjectContext
    private let service: MovieService
    private let fetcher: MovieFetcher
    private let imageConfiguration = ImageConfigurationManager.shared.getImageConfiguration()
    private let movieCategory: MovieCategory
    private var isFetchingAPI = false
    
    init(for category: MovieCategory) {
        self.movieCategory = category
        self.context = PersistenceController.shared.container.viewContext
        self.service = MovieService()
        self.fetcher = MovieFetcher(service: service, context: context)
        fetchMovies()
    }
    
    // MARK: -Fetch movies
    func fetchMovies() {
        let movies = PersistenceController.shared.fetchMovies(for: movieCategory, offset: dataOffset)
        if !movies.isEmpty  {
            self.movies += movies.filter { movie in
                !self.movies.contains(where: { $0.id == movie.id })
            }
            isFetchingAPI = false
            debugPrint(movies.count,self.movies.count)
        } else if !isFetchingAPI {
            isFetchingAPI = true
            let page = UserDefaults.standard.integer(forKey: movieCategory.pageKey) + 1
            fetchFromAPI(for: movieCategory, page: page)
        }
    }
    
    private func fetchFromAPI(for category: MovieCategory, page: Int = 1) {
        fetcher.fetchMovies(ofType: category, page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if self.isFetchingAPI {
                    self.fetchMovies()
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
    
    func getGenresAsString(for movie: CDMovie) -> String {
        if let genres = movie.genres as? Set<CDGenre> {
            let genreArray = Array(genres).compactMap( { genreId in
                let genreIdAsInt = Int(genreId.id)
                return MovieGenre(rawValue: genreIdAsInt)?.name
            })
            let genreString = Set(genreArray).joined(separator: ", ")
            return genreString
        }
        return "Unknown"
    }
    
    func posterUrl(for movie: CDMovie) -> URL? {
        guard let posterPath = movie.posterPath else { return nil }
        guard let baseURL = imageConfiguration?.secureBaseURL else { return nil }
        guard let posterSize = imageConfiguration?.posterSizes.first else { return nil }
        guard let url = URL(string: baseURL+posterSize+posterPath) else { return nil }
        return url
    }
    
    func showDetails(with movieId: Int) {
        tappedMovieId = movieId
        isDetailsShowing = true
    }
}
