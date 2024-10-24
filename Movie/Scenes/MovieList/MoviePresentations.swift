//
//  MoviePresentations.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

struct MoviePresentation: Equatable {
    let title: String
    let detail: String
    let posterPath: String?
    let releaseDate: String // Yeni tarih özelliği ekleyin
    
    init(movie: Movie) {
        self.title = movie.originalTitle ?? "Bilinmeyen Başlık"
        self.detail = movie.overview ?? "Açıklama mevcut değil"
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate ?? "Bilinmeyen Tarih"
    }
}
