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
    private var currentPage = 1

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
                
                print("Gösterilecek filmler: \(presentations.count)")
                self.notify(.showMovieList(presentations))
                
                // Koleksiyon görünümü için de filmleri güncelle
                self.delegate?.handleViewModelOutput(.showMovieList(presentations))
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func loadNowPlayingMovies() {
        notify(.setLoading(true))

        service.fetchNowPlayingMovies { [weak self] (result) in
            guard let self = self else { return }
            self.notify(.setLoading(false))

            switch result {
            case .success(let response):
                self.nowPlayingMovies = response.results
                self.movies = response.results // movies dizisini burada güncelliyoruz
                let presentations = self.nowPlayingMovies.map { MoviePresentation(movie: $0) }

                print("Gösterimde olan filmler: \(presentations.count)")
                self.notify(.showNowPlayingMovieList(presentations))
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }

    func selectMovie(at index: Int) {
        let movie = movies[index]
        // Seçimi işleme al
    }


    
    private func notify(_ output: MovieListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
