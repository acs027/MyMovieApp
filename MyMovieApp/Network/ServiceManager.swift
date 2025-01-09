//
//  ServiceManager.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import Foundation


protocol MoviesServiceProtocol {
    func fetchPopularMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ())
    
    func fetchNowPlayingMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ())
    
    func fetchTopRatedMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ())
    
    func fetchUpcomingMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ())
    
    func fetchConfiguration(completion: @escaping (Result<ConfigurationResponse, NetworkError>) -> ())
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> ())
}

final class MoviesService: MoviesServiceProtocol {
    private let network: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        network = networkManager
    }
    
    func fetchPopularMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        network.request(Router.popular(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
    
    func fetchNowPlayingMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        network.request(Router.nowPlaying(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
    
    func fetchTopRatedMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        network.request(Router.topRated(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
    
    func fetchUpcomingMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        network.request(Router.upcoming(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
    
    func fetchConfiguration(completion: @escaping (Result<ConfigurationResponse, NetworkError>) -> ()) {
        network.request(Router.configuration, decodeTo: ConfigurationResponse.self, completion: completion)
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> ()) {
        network.request(Router.movieDetails(id: id), decodeTo: MovieDetails.self, completion: completion)
    }
}
