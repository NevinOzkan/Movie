//
//  MovieListContract.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//


import Foundation

// ViewModel ile  View  arasındaki iletişimi tanımlar.
protocol MovieListViewModelDelegate: AnyObject {
    //viewmodelden gelen Çıktıyı işler
    func handleViewModelOutput(_ output: MovieListViewModelOutput)
    func navigate(to route: MovieListViewRoute)
}
//ViewModel’in View’a göndereceği çıktıları tanımlar
enum MovieListViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case showUpcomingMovieList([MoviePresentation], Int) 
    case showNowPlayingMovieList([MoviePresentation])
}

// view modelin hangi yönlendirmeleri yapması gerektiğini belirtir.
enum MovieListViewRoute {
    case detail(MovieDetailViewModel)
}

//  View, bu protokolü benimseyen bir ViewModel ile etkileşimde bulunur.
protocol MovieListViewModelProtocol {
    
    var delegate: MovieListViewModelDelegate? { get set }
    func loadUpcomingMovies(page: Int)
    func loadNowPlayingMovies()
    func selectMovie(at index: Int)
}










//Bu yapı, MVVM (Model-View-ViewModel) mimarisi kullanılarak bir film listeleme uygulamasının ViewModel’ini tanımlar. Delegate protokolleri, görünüm ile model arasındaki etkileşimi yönetirken, enum’lar uygulamanın durumu ve navigasyon yollarını temsil eder. Protokol, ViewModel’in sağladığı işlevselliği tanımlayarak, View’un bu işlevsellik ile etkileşimde bulunmasına olanak tanır. Bu yapı, uygulamanın daha temiz ve düzenli bir şekilde yönetilmesine yardımcı olur.//
