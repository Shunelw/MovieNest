//
//  HomeView.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 28/8/2569 BE.
//

import SwiftUI
 
struct HomeView: View {
    @State private var weeklyMovies: [Movie] = []
    @State private var todayMovies: [Movie] = []
    @State private var errorMessage: String?
    private let service = MovieService()

    var body: some View {
        NavigationStack {
            List {
                Section("Trending This Week") {
                    ForEach(weeklyMovies) { movie in
                        movieRow(movie)
                    }
                }
                Section("Trending Today") {
                    ForEach(todayMovies) { movie in
                        movieRow(movie)
                    }
                }
            }
            .navigationTitle("MovieNest")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    async let weekly = service.fetchTrendingMovies()
                    async let today = service.fetchTrendingMoviesToday()
                    weeklyMovies = try await weekly
                    todayMovies = try await today
                } catch {
                    errorMessage = "Couldn't load movies. Check your connection."
                }
            }
            .overlay {
                if let errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }

    @ViewBuilder
    private func movieRow(_ movie: Movie) -> some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            HStack {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .frame(width: 80, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    ProgressView()
                        .frame(width: 80, height: 120)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                    Text(movie.releaseDate ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if let rating = movie.voteAverage {
                        Text("⭐️ \(rating, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
