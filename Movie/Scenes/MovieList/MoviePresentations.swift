//
//  MoviePresentations.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

struct MoviePresentation: Equatable {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double?
    let releaseDate: String?
    let posterPath: String?
    
    init(movie: Movie) {
        self.id = movie.id ?? 0
        self.title = movie.title ?? "Title not available"
        self.overview = movie.overview ?? "Overview not available"
        self.voteAverage = movie.voteAverage
        self.releaseDate = movie.releaseDate
        self.posterPath = movie.posterPath
    }
    
    var fullPosterPath: String? {
        guard let posterPath = posterPath, !posterPath.isEmpty else {
            return nil
        }
        return "https://image.tmdb.org/t/p/w500" + posterPath
    }
}
