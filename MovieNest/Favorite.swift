//
//  Favorite.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 31/8/2569 BE.
//

import Foundation
import SwiftData
 
@Model
class Favorite {
    var movieId: Int
    var title: String
    var posterPath: String?
    var overview: String
    var releaseDate: String?
    var voteAverage: Double?
    var genreIds: [Int]?
    var actors: [String]?

    init(movieId: Int, title: String, posterPath: String?, overview: String, releaseDate: String?, voteAverage: Double?, genreIds: [Int]?, actors: [String]? = nil) {
        self.movieId = movieId
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.genreIds = genreIds
        self.actors = actors
    }
}
