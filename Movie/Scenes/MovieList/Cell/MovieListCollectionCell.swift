//
//  MovieListCollectionCell.swift
//  Movie
//
//  Created by Nevin Özkan on 28.10.2024.
//

import UIKit
import MovieAPI

class MovieListCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func prepareCell(with model: MoviePresentation) {
            movieTitle.text = model.title
            movieOverview.text = model.overview
            
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + model.posterPath!) {
                ImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
