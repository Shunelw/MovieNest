//
//  Movie.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 28/8/2569 BE.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let genreIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
    
    var posterURL: URL? {
            URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")
        }
}
