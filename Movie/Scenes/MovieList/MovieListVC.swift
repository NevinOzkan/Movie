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
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    private var movieList: [MoviePresentation] = []
    let service: MoviesServiceProtocol = MoviesService()
    
    var viewModel: MovieListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieListViewModel(service: service)
        viewModel.delegate = self
        
        // Hücreyi kaydet
        tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
        print("ViewDidLoad çağrıldı")
        
        // Verileri yükleyin
        viewModel.load()
        setupUI()
        setupSliderCollectionViewLayout()
    }
    
    private func setupSliderCollectionViewLayout() {
        if let layout = sliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
            sliderCollectionView.isPagingEnabled = true
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        
        // Ekranın yarısı kadar yükseklik ayarla
           let screenHeight = UIScreen.main.bounds.height
           tableView.frame = CGRect(x: 0, y: sliderCollectionView.frame.maxY, width: view.bounds.width, height: screenHeight / 1)
           
        
        
    }
}

extension MovieListVC: MovieListViewModelDelegate {
    func handleViewModelOutput(_ output: MovieListViewModelOutput) {
        print("handleViewModelOutput çağrıldı.")  // Yeni eklenen
         
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        case .showMovieList(let movieList):
            self.movieList = movieList
            print("Movie list received with count: \(movieList.count)")  // Yeni eklenen
            DispatchQueue.main.async {
                self.tableView.reloadData() // Tabloyu güncelle
            }
        }
    }
}

    extension MovieListVC: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movieList.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
            let movie = movieList[indexPath.row]
            cell.prepareCell(with: movie)
            return cell
        }

        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 140
        }
        

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedMovie = movieList[indexPath.row]
            print("Seçilen Film: \(selectedMovie.title)")
        }
    }
