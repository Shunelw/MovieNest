//
//  SearchView.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 31/8/2569 BE.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    
    @State private var results: [Movie] = []
    
    @State private var errorMessage: String?
    
    private let service = MovieService()
    
    var body: some View {
        
        NavigationStack {
            
            List(results) { movie in
                
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
                        
                        VStack(alignment: .leading) {
                            
                            Text(movie.title)
                            
                            Text(movie.releaseDate ?? "")
                            
                        }
                        
                    }
                    
                }
                
            }
            
            .navigationTitle("Search")
            
            .searchable(text: $searchText)
            
            .onSubmit(of: .search) {
                
                Task {
                    
                    do {
                        
                        results = try await service.fetchSearchResults(query: searchText)
                        
                    } catch {
                        
                        errorMessage = "Search failed. Try again."
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

