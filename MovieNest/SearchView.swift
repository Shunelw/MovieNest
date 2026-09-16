//
//  SearchView.swift
//  MovieNest
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var trendingMovies: [Movie] = []
    @State private var searchResults: [Movie] = []
    @State private var errorMessage: String?
    @State private var searchTask: Task<Void, Never>?
    @State private var filter = MovieFilter()
    @State private var showingFilter = false

    private let service = MovieService()

    private var displayedMovies: [Movie] {
        if searchText.isEmpty && !filter.isActive {
            return trendingMovies
        }
        if !searchText.isEmpty {
            return applyClientFilter(to: searchResults)
        }
        return searchResults
    }

    private func applyClientFilter(to movies: [Movie]) -> [Movie] {
        movies.filter { movie in
            let ratingOK = filter.minRating == 0 || (movie.voteAverage ?? 0) >= filter.minRating
            let yearOK = filter.releaseYear == nil || movie.releaseDate?.hasPrefix("\(filter.releaseYear!)") == true
            let genreOK = filter.selectedGenre == nil || (movie.genreIds?.contains(filter.selectedGenre!.rawValue) == true)
            return ratingOK && yearOK && genreOK
        }
    }

    var body: some View {
        NavigationStack {
            List(displayedMovies) { movie in
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
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search movies...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFilter = true
                    } label: {
                        Image(systemName: filter.isActive
                              ? "line.3.horizontal.decrease.circle.fill"
                              : "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilter) {
                FilterView(filter: $filter)
            }
            .onChange(of: searchText) { _, newValue in
                triggerSearch(query: newValue)
            }
            .onChange(of: filter) { _, _ in
                triggerSearch(query: searchText)
            }
            .task {
                do {
                    trendingMovies = try await service.fetchTrendingMovies()
                } catch {
                    errorMessage = "Couldn't load trending movies."
                }
            }
            .overlay {
                if let errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }

    private func triggerSearch(query: String) {
        searchTask?.cancel()
        if query.isEmpty && !filter.isActive {
            searchResults = []
            return
        }
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            do {
                if !query.isEmpty {
                    searchResults = try await service.fetchSearchResults(query: query)
                } else {
                    searchResults = try await service.fetchDiscoverMovies(filter: filter)
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = "Search failed. Try again."
                }
            }
        }
    }
}

