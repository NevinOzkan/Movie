//
//  MovieDetailViewModel.swift
//  Movie
//
//  Created by Nevin Özkan on 27.10.2024.
//

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
        
        
        let presentation = MovieDetailPresentation(movie: movie)
        
      
        delegate?.showDetail(presentation)
    }
}












//Protokol tabanlı bir servis kullanarak, veri çekme işlemleri için esneklik sağlar. Ayrıca, delegate kullanarak UI katmanıyla etkileşime geçer. Film verilerini aldıktan sonra, bu verileri bir MovieDetailPresentation nesnesine dönüştürerek, UI'nin kullanabileceği bir formatta sunar.//


