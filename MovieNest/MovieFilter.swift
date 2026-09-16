//
//  MovieFilter.swift
//  MovieNest
//

import Foundation

enum Genre: Int, CaseIterable, Identifiable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case horror = 27
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case thriller = 53
    case war = 10752
    case western = 37

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .action: return "Action"
        case .adventure: return "Adventure"
        case .animation: return "Animation"
        case .comedy: return "Comedy"
        case .crime: return "Crime"
        case .documentary: return "Documentary"
        case .drama: return "Drama"
        case .family: return "Family"
        case .fantasy: return "Fantasy"
        case .horror: return "Horror"
        case .mystery: return "Mystery"
        case .romance: return "Romance"
        case .scienceFiction: return "Sci-Fi"
        case .thriller: return "Thriller"
        case .war: return "War"
        case .western: return "Western"
        }
    }
}

struct MovieFilter: Equatable {
    var selectedGenre: Genre? = nil
    var minRating: Double = 0
    var releaseYear: Int? = nil

    var isActive: Bool {
        selectedGenre != nil || minRating > 0 || releaseYear != nil
    }
}
