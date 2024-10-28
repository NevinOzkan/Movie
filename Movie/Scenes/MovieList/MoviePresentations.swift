//
//  MoviePresentations.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

// MoviePresentation yapı tanımı
struct MoviePresentation: Equatable {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double?
    let releaseDate: String?
    let posterPath: String?
    
    // Movie nesnesini kabul eden bir initializer ekleyin
    init(movie: Movie) {
        self.id = movie.id ?? 00
        self.title = movie.title ?? "Title not available"
        self.overview = movie.overview ?? "Overview not available"
        self.voteAverage = movie.voteAverage
        self.releaseDate = movie.releaseDate
        self.posterPath = movie.posterPath
    }
}
