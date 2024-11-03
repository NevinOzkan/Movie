//
//  MovieDetailContracts.swift
//  Movie
//
//  Created by Nevin Özkan on 27.10.2024.
//

import Foundation

// film detayları için bir view model'in sağlaması gereken işlevleri tanımlar.
protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    func load()
}

//film detaylarının gösterimiyle ilgili geri bildirimleri işlemek için kullanılır.
protocol MovieDetailViewModelDelegate: AnyObject {
    func showDetail(_ presentation: MovieDetailPresentation)
}


//Bu iki protokol, film detaylarını yönetmek ve görüntülemek için bir yapı sağlar. MovieDetailViewModelProtocol, film detaylarını yüklemek için gerekli yöntemleri belirlerken, MovieDetailViewModelDelegate, bu detayların nasıl gösterileceğini tanımlar. Bu tasarım, MVVM mimarisinin bir parçası olarak, veri ve UI arasında temiz bir ayrım sağlar.//
