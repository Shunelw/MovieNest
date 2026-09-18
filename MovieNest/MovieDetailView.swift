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
    @State private var casts: [CastMember] = []
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

                if !casts.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Casts")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(casts) { cast in
                                    VStack(spacing: 6) {
                                        AsyncImage(url: cast.profileURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(18)
                                                .foregroundStyle(.secondary)
                                                .background(Color(.systemGray5))
                                        }
                                        .frame(width: 72, height: 104)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))

                                        Text(cast.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .frame(width: 72)
                                    }
                                }
                            }
                        }
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
            await loadCasts()
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
                castNames: currentCasts.map(\.name),
                castProfilePaths: currentCasts.map { $0.profilePath ?? "" }
            )
            modelContext.insert(favorite)
        }
        do {
            try modelContext.save()
        } catch {
            print("SwiftData save error: \(error)")
        }
    }

    private var currentCasts: [CastMember] {
        casts.isEmpty ? (movie.casts ?? []) : casts
    }

    private func loadCasts() async {
        casts = movie.casts ?? []
        guard casts.isEmpty else { return }

        do {
            casts = try await service.fetchMovieCasts(movieId: movie.id)
            updateFavoriteCasts()
        } catch {
            print("Cast fetch error: \(error)")
        }
    }

    private func updateFavoriteCasts() {
        guard !casts.isEmpty,
              let favorite = favorites.first(where: { $0.movieId == movie.id }) else {
            return
        }
        favorite.castNames = casts.map(\.name)
        favorite.castProfilePaths = casts.map { $0.profilePath ?? "" }
        do {
            try modelContext.save()
        } catch {
            print("SwiftData save error: \(error)")
        }
    }
}
