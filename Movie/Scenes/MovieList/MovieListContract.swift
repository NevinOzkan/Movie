//
//  MovieListContract.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieListViewModelOutput)
}

enum MovieListViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case showMovieList([MoviePresentation])
    case showNowPlayingMovieList([MoviePresentation])
}

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? { get set }
    func load()
    func loadNowPlayingMovies() // Bu satırı ekleyin
    func selectMovie(at index: Int)
}
