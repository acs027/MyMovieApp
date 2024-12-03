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
}

final class MoviesService: MoviesServiceProtocol {
    func fetchPopularMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        NetworkManager.shared.request(Router.popular(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
    
    func fetchNowPlayingMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        NetworkManager.shared.request(Router.nowPlaying(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
    
    func fetchTopRatedMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        NetworkManager.shared.request(Router.topRated(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
    
    func fetchUpcomingMovies(page: Int?, completion: @escaping (Result<MovieResponse, NetworkError>) -> ()) {
        NetworkManager.shared.request(Router.upcoming(page: page), decodeTo: MovieResponse.self, completion: completion)
    }
}
