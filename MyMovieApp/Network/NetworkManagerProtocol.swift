//
//  NetworkManagerProtocol.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(from url: String, decodeTo type: T.Type) async throws -> T
}
