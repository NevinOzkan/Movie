//
//  MoviePresentations.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

struct MoviePresentation {
    let title: String
    let detail: String
}

extension MoviePresentation {
    
    init(movie: Movie) {
        self.init(title: movie.originalTitle, detail: movie.overview)
    }
}
