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
    @Published var posterImages = [String: Data]()
    
    private var service = MoviesService()
    private var apiService = APIService()
    private var page = 1
    var imageConfiguration: ImageConfiguration?
    
    
#if DEBUG
    init() {
        movies = MockDataProvider().popularMovies()
        imageConfiguration = MockDataProvider().imageConfiguration()
    }
#endif
    
    
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
}


