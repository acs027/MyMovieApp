//
//  CatalogueViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import Foundation
import CoreData

final class CatalogueViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isDetailsShowing = false
    
    private(set) var tappedMovie: CDMovie?
    private var service = MovieService()
    private var fetcher = MovieFetcher(context: PersistenceController.shared.container.viewContext)
    private var imageConfiguration: ImageConfiguration?
    private var context = PersistenceController.shared.container.viewContext
    
    var tappedMovieId: Int {
        return Int(tappedMovie?.id ?? 0)
    }
    
    init() {
        imageConfiguration = MockDataProvider().imageConfiguration()
    }
    
    func fetchFromAPI(for category: MovieCategory, page: Int = 1) {
        fetcher.fetchMovies(ofType: category, page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                debugPrint("Movies are succesfully saved to core data")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
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
}


