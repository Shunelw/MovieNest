# MovieNest

MovieNest is a SwiftUI iOS app for discovering movies, searching The Movie Database (TMDB), filtering results, viewing movie details, and saving favorites locally with SwiftData.

## Features

- Browse weekly trending movies.
- Search movies by title.
- Filter movies by genre, minimum rating, and release year.
- View movie details, including poster, overview, rating, genres, and cast.
- Save and remove favorite movies.
- Persist favorites locally using SwiftData.

## Tech Stack

- Swift
- SwiftUI
- SwiftData
- Async/await networking
- TMDB API

## Project Structure

```text
MovieNest/
├── MovieNest/
│   ├── Assets.xcassets
│   ├── ContentView.swift
│   ├── Favorite.swift
│   ├── FavoritesView.swift
│   ├── FilterView.swift
│   ├── HomeView.swift
│   ├── Item.swift
│   ├── Movie.swift
│   ├── MovieDetailView.swift
│   ├── MovieFilter.swift
│   ├── MovieNestApp.swift
│   ├── MovieResponse.swift
│   ├── MovieService.swift
│   └── SearchView.swift
└── Products/
    └── MovieNest.app
```

## Getting Started

1. Open the project in Xcode.
2. Select the `MovieNest` scheme.
3. Choose an iOS simulator or connected device.
4. Build and run the app.

## API

Movie data is loaded from TMDB through `MovieService.swift`.

The project currently includes an API key directly in `MovieService`. For production use, move the key out of source control and load it from a secure configuration source.

## Main Screens

- `HomeView`: shows trending movies.
- `SearchView`: searches and filters movies.
- `MovieDetailView`: shows full movie information and favorite controls.
- `FavoritesView`: shows locally saved favorite movies.
- `FilterView`: manages search and discovery filters.

