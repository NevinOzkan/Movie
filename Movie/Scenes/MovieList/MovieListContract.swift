//
//  MovieListContract.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieListViewModelOutput)
    func navigate(to route: MovieListViewRoute)
}

enum MovieListViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case showMovieList([MoviePresentation], Int) 
    case showNowPlayingMovieList([MoviePresentation])
}

enum MovieListViewRoute {
    case detail(MovieDetailViewModel)
}

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? { get set }
    
    func loadUpcomingMovies(page: Int)
    func loadNowPlayingMovies()
    func selectMovie(at index: Int)
}
