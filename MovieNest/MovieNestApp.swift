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
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Favorite.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
