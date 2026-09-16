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
                let movie = Movie(
                    id: favorite.movieId,
                    title: favorite.title,
                    overview: favorite.overview,
                    posterPath: favorite.posterPath,
                    releaseDate: favorite.releaseDate,
                    voteAverage: favorite.voteAverage,
                    genreIds: favorite.genreIds
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
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
