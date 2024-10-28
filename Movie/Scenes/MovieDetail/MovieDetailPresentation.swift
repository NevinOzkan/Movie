//
//  MovieDetailPresentation.swift
//  Movie
//
//  Created by Nevin Özkan on 27.10.2024.
//

import Foundation
import MovieAPI

struct MovieDetailPresentation: Equatable {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double?
    let releaseDate: String?
    let posterPath: String?
    let imageUrl: String

    
    init(movie: Movie) {
        self.id = movie.id ?? 0
        self.title = movie.title ?? "Title not available"
        self.overview = movie.overview ?? "Overview not available"
        self.voteAverage = movie.voteAverage
        self.releaseDate = movie.releaseDate
        self.posterPath = movie.posterPath
        
        
        if let posterPath = movie.posterPath {
            self.imageUrl = "https://image.tmdb.org/t/p/w500" + posterPath
        } else {
            self.imageUrl = "" 
        }
    }
    
}
