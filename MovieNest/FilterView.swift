//
//  FilterView.swift
//  MovieNest
//

import SwiftUI

struct FilterView: View {
    @Binding var filter: MovieFilter
    @Environment(\.dismiss) private var dismiss

    private let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())

    @ViewBuilder
    private func genreRow(_ genre: Genre) -> some View {
        Button {
            filter.selectedGenre = filter.selectedGenre == genre ? nil : genre
        } label: {
            HStack {
                Text(genre.name)
                    .foregroundStyle(.primary)
                Spacer()
                if filter.selectedGenre == genre {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Genre") {
                    ForEach(Genre.allCases) { genre in
                        genreRow(genre)
                    }
                }

                Section("Minimum Rating") {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Slider(value: $filter.minRating, in: 0...10, step: 0.5)
                        Text(filter.minRating == 0 ? "Any" : String(format: "%.1f+", filter.minRating))
                            .foregroundStyle(.secondary)
                            .frame(width: 44)
                    }
                }

                Section("Release Year") {
                    Picker("Year", selection: $filter.releaseYear) {
                        Text("Any").tag(Int?.none)
                        ForEach(Array((1970...currentYear).reversed()), id: \.self) { year in
                            Text(String(year)).tag(Int?.some(year))
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") { filter = MovieFilter() }
                        .foregroundStyle(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .bold()
                }
            }
        }
    }
}


