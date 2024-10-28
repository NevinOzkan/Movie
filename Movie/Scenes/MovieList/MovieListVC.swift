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
    var movies: [Movie] = []
    private var nowPlayingMovies: [MoviePresentation] = []
    private let refreshControl = UIRefreshControl()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieListViewModel(service: service)
        viewModel.delegate = self
        
        viewModel.load()
        viewModel.loadNowPlayingMovies()
        setupUI()
        setupSliderCollectionViewLayout()
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        registerCells()
        setupRefreshControl() // Yenileme kontrolünü kur
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
        tableView.frame = view.bounds
        
        // Ekranın yarısı kadar yükseklik ayarla
        let screenHeight = UIScreen.main.bounds.height
        tableView.frame = CGRect(x: 0, y: sliderCollectionView.frame.maxY, width: view.bounds.width, height: screenHeight / 1)
        
        pageControl.numberOfPages = nowPlayingMovies.count
        pageControl.currentPage = 0
        
    }
    
    
    // Yenileme kontrolü ayarları
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        currentPage = 1
        viewModel.load() // upcomings filmlerini yenile
        viewModel.loadNowPlayingMovies() // now playing filmlerini yenile
        tableView.reloadData()
        sliderCollectionView.reloadData()
        refreshControl.endRefreshing() // Yenilemeyi sonlandır
    }
}

extension MovieListVC: MovieListViewModelDelegate {
    func handleViewModelOutput(_ output: MovieListViewModelOutput) {
        print("handleViewModelOutput çağrıldı.")
        
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        case .showMovieList(let movieList):
            self.movieList = movieList
            print("Film listesi alındı, sayısı: \(movieList.count)")
            DispatchQueue.main.async {
                self.tableView.reloadData() // Tabloyu güncelle
                self.sliderCollectionView.reloadData() // Koleksiyon görünümünü güncelle
               
            }
        case .showNowPlayingMovieList(let nowPlayingMovies):
            self.nowPlayingMovies = nowPlayingMovies
            print("Şu anda gösterimde olan filmler alındı, sayısı: \(nowPlayingMovies.count)")
            DispatchQueue.main.async {
                self.sliderCollectionView.reloadData() // Koleksiyon görünümünü güncelle
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movieList[indexPath.row] // Seçilen filmi al
        
        let vc = MovieDetailVC(nibName: "MovieDetailVC", bundle: Bundle.main)
        viewModel.selectMovie(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
        vc.movie = selectedMovie // movie özelliğini kullanarak seçilen filmi geçir
        self.navigationController?.pushViewController(vc, animated: true) // Detay sayfasına geçiş yap
    }
}
    
// UICollectionViewDelegate ve DataSource Uzantısı
extension MovieListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count // nowPlayingMovies dizisinin eleman sayısını döndür
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionCell", for: indexPath) as? MovieListCollectionCell else {
            fatalError("Hata: MovieListCollectionCell")
        }

        let movie = nowPlayingMovies[indexPath.item] // nowPlayingMovies dizisinden filmi al
        cell.prepareCell(with: movie) 

        return cell // Hücreyi döndür
    }

    // Cell boyutları
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    // Dikey yatay boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = pageIndex
    }
}
