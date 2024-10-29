//
//  MovieDetailVC.swift
//  Movie
//
//  Created by Nevin Özkan on 27.10.2024.
//

import UIKit
import MovieAPI

class MovieDetailVC: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
        var movie: MoviePresentation?
        var viewModel: MovieDetailViewModelProtocol!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            loadMovieDetail()
        }

        private func loadMovieDetail() {
            guard viewModel != nil else {
                print("ViewModel loadMovieDetail'de nil!")
                return
            }
            viewModel.load() // Veriyi ViewModel üzerinden yükle
        }

        private func setupUI() {
            guard viewModel != nil else {
                print("ViewModel nil!")
                return
            }
            viewModel.delegate = self // Delegasyonu ayarla
        }
    }

    extension MovieDetailVC: MovieDetailViewModelDelegate {
        func showDetail(_ presentation: MovieDetailPresentation) {
            movieTitleLabel.text = presentation.title
            
            if let releaseDate = presentation.releaseDate {
                dateLabel.text = DateFormatterHelper.formattedDate(from: releaseDate)
            } else {
                dateLabel.text = "N/A"
            }
            
            overviewTextView.text = presentation.overview
            
            let ratingText = "\(presentation.voteAverage ?? 0)/10"
            let attributedString = NSMutableAttributedString(string: ratingText)
            let range = (ratingText as NSString).range(of: "/10")
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: range)
            voteLabel.attributedText = attributedString

            if let imageUrl = URL(string: presentation.imageUrl) {
                imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder")) { [weak self] (_, error, _, _) in
                    if let error = error {
                        print("Görüntü yükleme hatası: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
