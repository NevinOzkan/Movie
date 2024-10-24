//
//  MovieListContract.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? { get set }
    func load()
    func selectMovie(at index: Int)
}

enum MovieListViewModelOutput {
    case setLoading(Bool)
    case updateTitle(String)
    case showMovieList([MoviePresentation])
}

protocol MovieListViewModelDelegate: class {
    func handleViewModelOutput(_ output: MovieListViewModelOutput)
}

