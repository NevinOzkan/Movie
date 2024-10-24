//
//  MovieListVC.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import UIKit
import MovieAPI

class MovieListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let service: MoviesServiceProtocol = MoviesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


extension MovieListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
  
    
}
