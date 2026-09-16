//
//  ContentView.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 28/8/2569 BE.
//

import SwiftUI
 
struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
 
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
 
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}
 
#Preview {
    ContentView()
}
