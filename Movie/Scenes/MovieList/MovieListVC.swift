//
//  MovieListVC.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import UIKit
import MovieAPI
import SDWebImage

class MovieListVC: UIViewController {

    private var movieList: [MoviePresentation] = []
    @IBOutlet weak var tableView: UITableView!
    
    let service: MoviesServiceProtocol = MoviesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}



extension MovieListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        
        let movie = movieList[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.owerviewLabel.text = movie.detail
        cell.dateLabel.text = DateFormatterHelper.formattedDate(from: movie.releaseDate)
        
        if let posterPath = movie.posterPath, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) {
            cell.movieImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.movieImageView.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movieList[indexPath.row]
                print("Selected Movie: \(selectedMovie.title)")
    }
  
    
}
