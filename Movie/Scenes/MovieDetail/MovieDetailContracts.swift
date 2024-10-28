//
//  MovieDetailContracts.swift
//  Movie
//
//  Created by Nevin Özkan on 27.10.2024.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    func load()
}

protocol MovieDetailViewModelDelegate: AnyObject {
    func showDetail(_ presentation: MovieDetailPresentation)
}
