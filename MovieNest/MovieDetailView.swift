//
//  MovieDetailView.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 31/8/2569 BE.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [Favorite]
    @State private var actors: [String] = []
    private let service = MovieService()
    
    private var isFavorited: Bool {
        favorites.contains(where: { $0.movieId == movie.id })
    }

    private var genres: [Genre] {
        guard let ids = movie.genreIds else { return [] }
        return Genre.allCases.filter { ids.contains($0.rawValue) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                HStack {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .foregroundStyle(.red)
                    }
                }
                
                Text(movie.releaseDate ?? "")
                    .foregroundStyle(.secondary)
                
                if let rating = movie.voteAverage {
                    Text("⭐️ \(rating, specifier: "%.1f")")
                }

                if !genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(genres) { genre in
                                Text(genre.name)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(.systemGray5))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                if !actors.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Actors")
                            .font(.headline)
                        Text(actors.joined(separator: ", "))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }

                Text(movie.overview)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .task {
            await loadActors()
        }
    }
    
    private func toggleFavorite() {
        if let existing = favorites.first(where: { $0.movieId == movie.id }) {
            modelContext.delete(existing)
        } else {
            let favorite = Favorite(
                movieId: movie.id,
                title: movie.title,
                posterPath: movie.posterPath,
                overview: movie.overview,
                releaseDate: movie.releaseDate,
                voteAverage: movie.voteAverage,
                genreIds: movie.genreIds,
                actors: actors.isEmpty ? movie.actors : actors
            )
            modelContext.insert(favorite)
        }
        do {
            try modelContext.save()
        } catch {
            print("SwiftData save error: \(error)")
        }
    }

    private func loadActors() async {
        actors = movie.actors ?? []
        guard actors.isEmpty else { return }

        do {
            actors = try await service.fetchMovieActors(movieId: movie.id)
            updateFavoriteActors()
        } catch {
            print("Actor fetch error: \(error)")
        }
    }

    private func updateFavoriteActors() {
        guard !actors.isEmpty,
              let favorite = favorites.first(where: { $0.movieId == movie.id }) else {
            return
        }
        favorite.actors = actors
        do {
            try modelContext.save()
        } catch {
            print("SwiftData save error: \(error)")
        }
    }
}
