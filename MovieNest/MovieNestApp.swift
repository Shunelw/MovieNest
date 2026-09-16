//
//  MovieNestApp.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 28/8/2569 BE.
//

import SwiftUI
import SwiftData

@main
struct MovieNestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Favorite.self)
    }
}
