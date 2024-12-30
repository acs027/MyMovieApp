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
    @Published var posterImages = [String: Data]()
    @Published var movies: [CDMovie] = []
    @Published var isDetailsShowing = false
    private(set) var tappedMovieId = 0
    private(set) var isPopularMoviesLoading = false
    private(set) var isUpcomingMoviesLoading = false
    private(set) var isNowPlayingLoading = false
    private var service = MoviesService()
    private var apiService = APIService()
    private var page = 1
    private var imageConfiguration: ImageConfiguration?
    private var context = PersistenceController.shared.container.viewContext
    
    
    
    
#if DEBUG
    init() {
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
        imageConfiguration = MockDataProvider().imageConfiguration()
        fetchMovies()
    }
#endif
    
    
    func fetchPopularMovies() async {
        DispatchQueue.main.async {
            self.isPopularMoviesLoading = true
        }
        service.fetchPopularMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
//                movies = movieResponse.results
                _ = movieResponse.results.map {
                    let popularMovie = CDMovie(from: $0, context: self.context)
                    popularMovie.isPopular = true
                }
                
                isPopularMoviesLoading = false
                //                page += 1
            case .failure(let error):
                isPopularMoviesLoading = false
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
                //                page = 1
            }
        }
    }
    
    func fetchUpcomingMovies() async {
        DispatchQueue.main.async {
            self.isUpcomingMoviesLoading = true
        }
        service.fetchUpcomingMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResponse):
//                movies = movieResponse.results
                isUpcomingMoviesLoading = false
                //                page += 1
            case .failure(let error):
                isUpcomingMoviesLoading = false
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
                //                page = 1
            }
        }
    }
    
    func fetchNowPlayingMovies() async {
        DispatchQueue.main.async {
            self.isNowPlayingLoading = true
        }
        service.fetchNowPlayingMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let movieResponse):
//                    movies = movieResponse.results
                    isNowPlayingLoading = false
                case .failure(let error):
                    isNowPlayingLoading = false
                    errorMessage = error.localizedDescription
                    debugPrint("\(error.localizedDescription)")
                
            }
        }
    }
    
    func fetchConfiguration() async {
        apiService.fetchConfiguration { [weak self] result in
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
    
    func getImageURL(with path: String) -> URL? {
        guard let baseURL = imageConfiguration?.secureBaseURL else { return nil }
        guard let posterSize = imageConfiguration?.posterSizes.first else { return nil }
        let imageURL = URL(string: baseURL+posterSize+path)
        print(imageURL ?? "invalid url")
        return imageURL
    }
    
    func fetchImage(with path: String) async  {
        guard let url = getImageURL(with: path) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            DispatchQueue.main.async {
                self.posterImages[path] = data
            }
        } catch {
            print("fetch image failed")
        }
    }
    
    func fetchMovies() {
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()

        do {
            self.movies = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
        }
    }
    
    func showMovieDetails(id: Int) {
        self.tappedMovieId = id
        self.isDetailsShowing = true
    }
}


