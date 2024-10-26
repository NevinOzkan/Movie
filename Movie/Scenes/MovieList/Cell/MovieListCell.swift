//
//  MovieListCell.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import UIKit
import MovieAPI

class MovieListCell: UITableViewCell {
    
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func prepareCell(with model: MoviePresentation) {
           titleLabel.text = model.title
           overviewLabel.text = model.detail
           dateLabel.text = DateFormatterHelper.formattedDate(from: model.releaseDate)
           
           if let posterPath = model.posterPath, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) {
               movieImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
           } else {
               movieImageView.image = UIImage(named: "placeholder")
           }
       }
   }
