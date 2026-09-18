//
//  FavoritesView.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 31/8/2569 BE.
//

import SwiftUI
import SwiftData
 
struct FavoritesView: View {
    @Query private var favorites: [Favorite]
 
    var body: some View {
        NavigationStack {
            List(favorites) { favorite in
                let casts = makeCasts(from: favorite)
                let movie = Movie(
                    id: favorite.movieId,
                    title: favorite.title,
                    overview: favorite.overview,
                    posterPath: favorite.posterPath,
                    releaseDate: favorite.releaseDate,
                    voteAverage: favorite.voteAverage,
                    genreIds: favorite.genreIds,
                    casts: casts
                )
 
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
                            if !casts.isEmpty {
                                HStack(spacing: 6) {
                                    ForEach(Array(casts.prefix(3))) { cast in
                                        AsyncImage(url: cast.profileURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(8)
                                                .foregroundStyle(.secondary)
                                                .background(Color(.systemGray5))
                                        }
                                        .frame(width: 28, height: 42)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                }

                                Text(casts.prefix(3).map(\.name).joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func makeCasts(from favorite: Favorite) -> [CastMember] {
        guard let castNames = favorite.castNames else { return [] }
        let profilePaths = favorite.castProfilePaths ?? []

        return castNames.enumerated().map { index, name in
            let profilePath = index < profilePaths.count ? profilePaths[index] : ""
            return CastMember(
                id: index,
                name: name,
                profilePath: profilePath.isEmpty ? nil : profilePath
            )
        }
    }
}
