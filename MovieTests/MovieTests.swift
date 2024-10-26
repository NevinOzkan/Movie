//
//  MovieTests.swift
//  MovieTests
//
//  Created by Nevin Özkan on 24.10.2024.
//

import XCTest
@testable import Movie


final class MovieTests: XCTestCase {
    
    private var view: MockView!
    private var viewModel: MovieListViewModel!
    private var service: MockMoviesService!
    
    override func setUpWithError() throws {
        service = MockMoviesService()
        viewModel = MovieListViewModel(service: service)
        view = MockView()
        viewModel.delegate = view
    }
    
    func testLoad() throws {
           // Given:
           let movie1 = try ResourceLoader.loadMovie(resource: .movie1)
           let movie2 = try ResourceLoader.loadMovie(resource: .movie2)
           service.movies = [movie1, movie2]
           
           // When:
           viewModel.load()
           
           // Then:
           XCTAssertEqual(view.outputs.count, 4)
           
           XCTAssertEqual(view.outputs[1], .setLoading(true))
           XCTAssertEqual(view.outputs[2], .setLoading(false))
           
           let expectedMovies = [movie1, movie2].map({ MoviePresentation(movie: $0) })
           XCTAssertEqual(view.outputs[3], .showMovieList(expectedMovies))
       }
   }



private class MockView: MovieListViewModelDelegate {
    
    var outputs: [MovieListViewModelOutput] = []
    
    func handleViewModelOutput(_ output: Movie.MovieListViewModelOutput) {
        outputs.append(output)
    }
    
    
}
