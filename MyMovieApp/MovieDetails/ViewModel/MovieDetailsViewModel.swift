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
    @Published var backdropData: [Data] = []
    var errorMessage = ""
    let id: Int
    private var detailsService: MovieService
    private var imageConfiguration: ImageConfiguration?
    
    var backgroundColor: RGBA {
        backdropData.first?.averageColorRGBA ?? .clear
    }
    
    init(id: Int) {
        detailsService = MovieService()
        self.id = id
        imageConfiguration = MockDataProvider().imageConfiguration()
//        #if DEBUG
//        self.isDetailsLoading = false
//        self.movieDetails = MockDataProvider().movieDetails()
//        #endif
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
                Task {
                    await self.fetchImageData()
                }
            case .failure(let error):
                isDetailsLoading = false
                errorMessage = error.localizedDescription
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
    
    func fetchImageData() async  {
        guard let posterPath = movieDetails?.backdropPath else { return }
        guard let baseURL = imageConfiguration?.secureBaseURL else { return }
        guard let posterSize = imageConfiguration?.posterSizes.last else { return }
        guard let url = URL(string: baseURL+posterSize+posterPath) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            DispatchQueue.main.async {
                self.backdropData.append(data)
                self.isDetailsLoading = false
            }
        } catch {
            isDetailsLoading = false
            debugPrint("Image fetching failed")
        }
    }
}
