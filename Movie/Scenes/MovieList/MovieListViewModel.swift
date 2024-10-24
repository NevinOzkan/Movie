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
        notify(.updateTitle("Movie List"))
        notify(.setLoading(true))
        
        service.fetchMovies { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.notify(.setLoading(false))
            
            switch result {
            case .success(let response):
                let movies = response.results
                let presentations = movies.map({MoviePresentation(movie: $0)})
                strongSelf.notify(.showMovieList(presentations))
            case .failure(let error):
                print(error)
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
