//
//  MovieListViewModel.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

// MovieListViewModel.swift
final class MovieListViewModel: MovieListViewModelProtocol {
    weak var delegate: MovieListViewModelDelegate?
    private let service: MoviesServiceProtocol
    private var movies: [Movie] = [] // Upcoming movies
    private var nowPlayingMovies: [Movie] = [] // Now playing movies

    init(service: MoviesServiceProtocol) {
        self.service = service
    }

    // Upcoming filmleri yükler
    func load() {
        notify(.setLoading(true))
        
        service.fetchMovies { [weak self] (result) in
            guard let self = self else { return }
            self.notify(.setLoading(false))
            
            switch result {
            case .success(let response):
                self.movies = response.results // Sadece upcoming filmler burada güncellenir
                let presentations = self.movies.map { MoviePresentation(movie: $0) }
                
                print("Güncellenmiş upcoming film sayısı: \(presentations.count)")
                self.notify(.showMovieList(presentations))
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }
    
    // Now playing filmleri yükler
    func loadNowPlayingMovies() {
        notify(.setLoading(true))

        service.fetchNowPlayingMovies { [weak self] (result) in
            guard let self = self else { return }
            self.notify(.setLoading(false))

            switch result {
            case .success(let response):
                self.nowPlayingMovies = response.results // Sadece now playing filmler burada güncellenir
                let presentations = self.nowPlayingMovies.map { MoviePresentation(movie: $0) }

                print("Güncellenmiş now playing film sayısı: \(presentations.count)")
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
