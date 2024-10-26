//
//  MovieListViewModel.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

final class MovieListViewModel: MovieListViewModelProtocol {
    
    weak var delegate: MovieListViewModelDelegate?
    private let service: MoviesServiceProtocol
    private var movies: [Movie] = []
    
    init(service: MoviesServiceProtocol) {
        self.service = service
    }
    
    func load() {
        notify(.setLoading(true))
        
        service.fetchMovies { [weak self] (result) in
            guard let self = self else { return }
            self.notify(.setLoading(false))
            
            switch result {
            case .success(let response):
                let movies = response.results
                self.movies = movies // movies dizisini burada dolduruyoruz
                let presentations = movies.map { MoviePresentation(movie: $0) }
                
                // Burada presentations dizisinin dolduğunu doğrulamak için bir print ekliyoruz
                print("Movies to Show: \(presentations.count)")
                
                self.notify(.showMovieList(presentations))
            case .failure(let error):
                print("API Fetch Error: \(error.localizedDescription)")
            }
        }
    }
    
    func selectMovie(at index: Int) {
        let movie = movies[index]
    }
    
    private func notify(_ output: MovieListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
