//
//  Mocks.swift
//  MovieAPI
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

// Gerçek veriler ve ağ çağrıları olmadan uygulamayı test etme ihtiyacı olduğunda, bu tür bir sahte (mock) servis oluşturuldu
//gerçek API çağrıları yerine geçen sahte bir servistir.
final class MockMoviesService: MoviesServiceProtocol {
    var movies: [Movie] = []

    func fetchUpcomingMovies(completion: @escaping (MovieAPI.Result<MovieAPI.MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }

    func fetchNowPlayingMovies(completion: @escaping (MovieAPI.Result<MovieAPI.MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }

    func fetchMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }
}
