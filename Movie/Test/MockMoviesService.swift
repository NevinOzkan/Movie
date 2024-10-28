//
//  Mocks.swift
//  MovieAPI
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

final class MockMoviesService: MoviesServiceProtocol {
    var movies: [Movie] = []

    func fetchNowPlayingMovies(completion: @escaping (MovieAPI.Result<MovieAPI.MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse)) // Sahte verileri başarıyla döndür
    }

    func fetchMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse)) // Mevcut verileri başarıyla döndür
    }
}
