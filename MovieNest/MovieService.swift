//
//  MovieService.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 28/8/2569 BE.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

struct CreditsResponse: Decodable {
    let cast: [CastMember]
}

struct CastMember: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePath = "profile_path"
    }

    var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath)")
    }
}
 
class MovieService {
    private let apiKey = "fda9c1cb534d837aacb78967dc640f16"
    private let baseURL = "https://api.themoviedb.org/3"
 
    func fetchTrendingMovies() async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/trending/movie/week?api_key=\(apiKey)") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    func fetchTrendingMoviesToday() async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/trending/movie/day?api_key=\(apiKey)") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    func fetchDiscoverMovies(filter: MovieFilter) async throws -> [Movie] {
        var components = URLComponents(string: "\(baseURL)/discover/movie")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        if let genre = filter.selectedGenre {
            queryItems.append(URLQueryItem(name: "with_genres", value: "\(genre.rawValue)"))
        }
        if filter.minRating > 0 {
            queryItems.append(URLQueryItem(name: "vote_average.gte", value: String(format: "%.1f", filter.minRating)))
        }
        if let year = filter.releaseYear {
            queryItems.append(URLQueryItem(name: "primary_release_year", value: "\(year)"))
        }
        components.queryItems = queryItems
        guard let url = components.url else { throw NetworkError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    func fetchSearchResults(query: String) async throws -> [Movie] {
        guard !query.isEmpty else { return [] }
     
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
     
        let (data, response) = try await URLSession.shared.data(from: url)
     
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
     
        do {
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    func fetchMovieCasts(movieId: Int) async throws -> [CastMember] {
        guard let url = URL(string: "\(baseURL)/movie/\(movieId)/credits?api_key=\(apiKey)") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(CreditsResponse.self, from: data)
            return Array(decoded.cast.prefix(6))
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
