//
//  MovieCategory.swift
//  MyMovieApp
//
//  Created by ali cihan on 15.01.2025.
//

import Foundation

enum MovieCategory: CustomStringConvertible {
    case popular
    case upcoming
    case nowPlaying
    
    var description: String {
        switch self {
        case .popular: return "Popular Movies"
        case .upcoming: return "Upcoming Movies"
        case .nowPlaying: return "Now Playing Movies"
        }
    }
    
    var predicate: NSPredicate {
        switch self {
        case .popular:
            return NSPredicate(format: "isPopular == %@", NSNumber(value: true))
        case .upcoming:
            return NSPredicate(format: "isUpcoming == %@", NSNumber(value: true))
        case .nowPlaying:
            return NSPredicate(format: "isNowPlaying == %@", NSNumber(value: true))
        }
    }
    
    var tab: CustomTab {
        switch self {
        case .nowPlaying: return .nowplayingMovies
        case .popular: return .popularMovies
        case .upcoming: return .upcomingMovies
        }
    }
}
