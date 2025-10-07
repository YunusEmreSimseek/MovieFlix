//
//  HomeViewModel.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import Combine

protocol HomeViewModelProtocol: BaseViewModelProtocol {
    func fetchPopularMovies() async
}

final class HomeViewModel: BaseViewModel {
    private let movieService: MovieServiceProtocol

    @Published var movies: [Movie] = []

    init(movieService: MovieServiceProtocol = MovieService(networkManager: NetworkManager.shared)) {
        self.movieService = movieService
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await fetchPopularMovies() }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func fetchPopularMovies() async {
        guard let response = await movieService.fetchPopularMovies() else { return }
        guard let responseMovies = response.results else { return }
        movies = responseMovies
        print("Movies count: \(movies.count)")
    }

    func navigateToMovieDetail(movie: Movie) {
//        NavigationManager.shared.push(MovieDetailViewController(movie: movie))
    }
}
