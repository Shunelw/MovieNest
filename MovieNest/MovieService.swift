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
}


