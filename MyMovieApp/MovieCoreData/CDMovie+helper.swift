//
//  CDMovie+helper.swift
//  MyMovieApp
//
//  Created by ali cihan on 10.12.2024.
//

import Foundation
import CoreData


extension CDMovie {
    convenience init(from movie: Movie, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = movie.title
        self.adult = movie.adult
        self.id = Int32(movie.id)
        self.originalTitle = movie.originalTitle
        self.originalLanguage = movie.originalLanguage
        self.overview = movie.overview
        self.popularity = movie.popularity
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
        self.voteCount = Int32(movie.voteCount)
        self.savedDate = Date()
        let genreIDs = movie.genreIDs.map {
            let genre = CDGenre(context: context)
            genre.id = Int32($0)
            return genre
        }
        self.genres = Set(genreIDs) as NSSet
    }
}
