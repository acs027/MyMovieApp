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
    var errorMessage = ""
    private var dataOffset = 0
    private let context: NSManagedObjectContext
    private let service: MoviesService
    private let fetcher: MoviesFetcher
    private let imageConfiguration = MockDataProvider().imageConfiguration()
    private let movieCategory: MovieCategory
    
    init(for category: MovieCategory) {
        self.movieCategory = category
        self.context = PersistenceController.shared.container.viewContext
        self.service = MoviesService()
        self.fetcher = MoviesFetcher(service: service, context: context)
        checkAndFetch()
    }
    
    func fetchCoreData(for category: MovieCategory) -> NSFetchRequest<CDMovie> {
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        fetchRequest.predicate = category.predicate
        fetchRequest.sortDescriptors = []
        fetchRequest.fetchLimit = 20
        fetchRequest.fetchOffset = dataOffset
        return fetchRequest
    }
    
    private func incrementOffset() {
        dataOffset += 20
    }
    
    // Check if data exist in core and
    // if not fetch from TMDBapi
    func checkAndFetch() {
        if !isDataExist() {
            let page = (movies.count / 20) + 1
            fetchFromAPI(for: movieCategory, page: page)
        } else {
            fetchMovies()
        }
    }
    
    //Fetch movies from core data
    private func fetchMovies() {
        if let movies = try? context.fetch(fetchCoreData(for: movieCategory)) {
            self.movies += movies
            incrementOffset()
        } else {
            print("Couldnt fetch movies from core data.")
        }
    }
    
    //Checks CoreData has data for given offset
    private func isDataExist() -> Bool {
        if let movies = try? context.fetch(fetchCoreData(for: movieCategory)) {
            return !movies.isEmpty
        } else {
            return false
        }
    }
    
    func fetchFromAPI(for category: MovieCategory, page: Int = 1) {
        fetcher.fetchMovies(ofType: category, page: page) { [weak self] result in
                   guard let self else { return }
                   switch result {
                   case .success:
                       self.fetchMovies()
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
}
