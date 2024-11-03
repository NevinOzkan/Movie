//
//  MovieListViewModel.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI
import SDWebImage

final class MovieListViewModel: MovieListViewModelProtocol {
    
    weak var delegate: MovieListViewModelDelegate?
    private let service: MoviesServiceProtocol
    private var movies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []

    init(service: MoviesServiceProtocol) {
        self.service = service
    }

    func loadUpcomingMovies(page: Int) {
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
        
        notify(.setLoading(true))
        
        service.fetchUpcomingMovies { [weak self] result in
            guard let self = self else { return }
            self.notify(.setLoading(false))
            
            switch result {
            case .success(let response):
                // Yanıtı logla
                print("Gelen Upcoming Movies:", response) // Yanıtın tamamını yazdır
                
                // Her bir film için başlık ve poster path'i yazdır
                for movie in response.results {
                    print("Movie Title: \(movie.title ?? "No Title"), Poster Path: \(movie.posterPath ?? "nil")")
                }

                self.movies = response.results
                let presentations = self.movies.map { MoviePresentation(movie: $0) }
                self.notify(.showUpcomingMovieList(presentations, page))
                
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }


    
    func loadNowPlayingMovies() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
        
        notify(.setLoading(true))

        service.fetchNowPlayingMovies { [weak self] result in
            guard let self = self else { return }
            self.notify(.setLoading(false))

            switch result {
            case .success(let response):
                // Yanıtı logla
                print("Gelen Now Playing Movies:", response) // Yanıtın tamamını yazdır
                
                // Her bir film için başlık ve poster path'i yazdır
                for movie in response.results {
                    print("Movie Title: \(movie.title ?? "No Title"), Poster Path: \(movie.posterPath ?? "nil")")
                }

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
        DispatchQueue.main.async {
            self.delegate?.handleViewModelOutput(output)
        }
    }
}
