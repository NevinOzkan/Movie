//
//  Mocks.swift
//  MovieAPI
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation

final class MockMoviesService: MoviesServiceProtocol {
    
    var movies: [Movie] = []
    
    func fetchMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let dates = Dates(maximum: "2024-10-30", minimum: "2024-09-18") // Dates nesnesi oluşturuluyor
        let moviesResponse = MoviesResponse(dates: dates, page: 1, results: movies) // Tüm parametreler MoviesResponse ile veriliyor
        completion(.success(moviesResponse)) // Tamamlanıyor
    }
}
