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
    private var nowPlayingMovies: [Movie] = []

    init(service: MoviesServiceProtocol) {
        self.service = service
    }

    func loadUpcomingMovies(page: Int) {
        notify(.setLoading(true))
        
        service.fetchUpcomingMovies { [weak self] result in
            guard let self = self else { return }
            self.notify(.setLoading(false))
            
            switch result {
            case .success(let response):
                self.movies = response.results
                let presentations = self.movies.map { MoviePresentation(movie: $0) }
               
                
                self.notify(.showMovieList(presentations, page))
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func loadNowPlayingMovies() {
        notify(.setLoading(true))

        service.fetchNowPlayingMovies { [weak self] result in
            guard let self = self else { return }
            self.notify(.setLoading(false))

            switch result {
            case .success(let response):
                self.nowPlayingMovies = response.results
                let presentations = self.nowPlayingMovies.map { MoviePresentation(movie: $0) }

               
              

                self.notify(.showNowPlayingMovieList(presentations))
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }

    func selectMovie(at index: Int) {
        guard index >= 0 && index < movies.count else {
            print("Geçersiz film indeksi.")
            return
        }
        let movie = movies[index]
        let viewModel = MovieDetailViewModel(service: service, movie: movie)
        delegate?.navigate(to: .detail(viewModel))
    }
    
    private func notify(_ output: MovieListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
