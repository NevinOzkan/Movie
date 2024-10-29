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
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var pageControl: UIPageControl!
        
        private var movieList: [MoviePresentation] = []
        let service: MoviesServiceProtocol = MoviesService()
        var viewModel: MovieListViewModelProtocol!
        private var nowPlayingMovies: [MoviePresentation] = []
        private let refreshControl = UIRefreshControl()
        var currentPage = 1

        override func viewDidLoad() {
            super.viewDidLoad()
            
            viewModel = MovieListViewModel(service: service)
            viewModel.delegate = self
            
            setupUI()
            setupSliderCollectionViewLayout()
            sliderCollectionView.delegate = self
            sliderCollectionView.dataSource = self
            registerCells()
            setupRefreshControl()
        }
        
        private func registerCells() {
            let nib = UINib(nibName: "MovieListCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "MovieListCell")
            
            let collectionNib = UINib(nibName: "MovieListCollectionCell", bundle: nil)
            sliderCollectionView.register(collectionNib, forCellWithReuseIdentifier: "MovieListCollectionCell")
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
            tableView.frame = CGRect(x: 0, y: sliderCollectionView.frame.maxY, width: view.bounds.width, height: UIScreen.main.bounds.height - sliderCollectionView.frame.maxY)
            
            pageControl.numberOfPages = nowPlayingMovies.count
            pageControl.currentPage = 0
            
            viewModel.load()
            viewModel.loadNowPlayingMovies()
        }
        
        private func setupRefreshControl() {
            tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        }
        
        @objc private func refreshData() {
            currentPage = 1
            viewModel.load()
            viewModel.loadNowPlayingMovies()
            refreshControl.endRefreshing()
        }
    }

    extension MovieListVC: MovieListViewModelDelegate {
        // MovieListVC.swift - Delegate Yönteminde
        func navigate(to route: MovieListViewRoute) {
            switch route {
            case .detail(let viewModel):
                let detailVC = MovieDetailVC(nibName: "MovieDetailVC", bundle: Bundle.main)
                detailVC.viewModel = viewModel  // viewModel'ı detay ekranına aktar
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        
        func handleViewModelOutput(_ output: MovieListViewModelOutput) {
            switch output {
            case .updateTitle(let title):
                self.title = title
            case .setLoading(let isLoading):
                UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
                isLoading ? activity.startAnimating() : activity.stopAnimating()
            case .showMovieList(let movieList):
                self.movieList = movieList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .showNowPlayingMovieList(let nowPlayingMovies):
                self.nowPlayingMovies = nowPlayingMovies
                DispatchQueue.main.async {
                    self.sliderCollectionView.reloadData()
                    self.pageControl.numberOfPages = self.nowPlayingMovies.count
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
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if scrollView == tableView && offsetY > contentHeight - height - 100 {
                currentPage += 1
                viewModel.load()
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            viewModel.selectMovie(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }

    extension MovieListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return nowPlayingMovies.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionCell", for: indexPath) as? MovieListCollectionCell else {
                fatalError("Hata: MovieListCollectionCell")
            }
            let movie = nowPlayingMovies[indexPath.item]
            cell.prepareCell(with: movie)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = pageIndex
        }
    }
