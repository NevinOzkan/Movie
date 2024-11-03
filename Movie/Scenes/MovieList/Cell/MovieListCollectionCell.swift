//
//  MovieListCollectionCell.swift
//  Movie
//
//  Created by Nevin Özkan on 28.10.2024.
//

import UIKit
import MovieAPI
import SDWebImage

class MovieListCollectionCell: UICollectionViewCell {
    
    var movie: Movie?
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           ImageView.image = nil // Eski görseli temizle
       }
       
    func prepareCell(with model: MoviePresentation) {
          movieTitle.text = model.title
          movieOverview.text = model.overview
          ImageView.image = nil // Önce eski görseli temizle
          
        // Poster path kontrolü yapalım
               if let imageUrl = model.fullPosterPath {
                   ImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
               } else {
                   // Poster path yoksa yer tutucu resmi ayarla
                   ImageView.image = UIImage(named: "placeholder")
               }
           }
       }
