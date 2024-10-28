//
//  MovieDetailViewModel.swift
//  Movie
//
//  Created by Nevin Özkan on 27.10.2024.
//

import Foundation
import MovieAPI

import Foundation
import MovieAPI

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    weak var delegate: MovieDetailViewModelDelegate?
    private let service: MoviesServiceProtocol
    private var movie: Movie?
    
    init(service: MoviesServiceProtocol, movie: Movie) {
        self.service = service
        self.movie = movie
    }
    
    func load() {
        guard let movie = movie else {
            print("Movie is nil in ViewModel!")
            return
        }
        
        // MovieDetailPresentation oluştur
        let presentation = MovieDetailPresentation(movie: movie)
        
        // Delegate aracılığıyla UI'ya gönder
        delegate?.showDetail(presentation)
    }
}
