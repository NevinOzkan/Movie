//
//  HomeVC.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import UIKit
import MovieAPI

class HomeVC: UIViewController {

    let service: MoviesServiceProtocol = MoviesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.fetchMovies { (result) in
            print(result)
        }
    }


}
