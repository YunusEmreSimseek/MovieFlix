//
//  NewHomeViewModel.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import Combine

protocol NewHomeViewModelProtocol {
    var view: NewHomeViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class NewHomeViewModel {
    weak var view: NewHomeViewControllerProtocol?
    private let movieService: MovieServiceProtocol
    @Published var popularMovies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    @Published var trendingTVs: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []

    init(movieService: MovieServiceProtocol = MovieService(networkManager: NetworkManager.shared)) {
        self.movieService = movieService
    }
}

extension NewHomeViewModel: NewHomeViewModelProtocol {
    private func fetchPopularMovies() async {
        guard let response = await movieService.fetchPopularMovies() else { return }
        guard let responseMovies = response.results else { return }
        popularMovies = responseMovies
    }

    private func fetchTrendingMovies() async {
        guard let response = await movieService.fetchTrendingMovies() else { return }
        guard let responseMovies = response.results else { return }
        trendingMovies = responseMovies
    }

    private func fetchUpcomingMovies() async {
        guard let response = await movieService.fetchUpcomingMovies() else { return }
        guard let responseMovies = response.results else { return }
        upcomingMovies = responseMovies
    }

    private func fetchTopRatedMovies() async {
        guard let response = await movieService.fetchTopRatedMovies() else { return }
        guard let responseMovies = response.results else { return }
        topRatedMovies = responseMovies
    }

    private func fetchTrendingTVs() async {
        guard let response = await movieService.fetchTrendingTVs() else { return }
        guard let responseMovies = response.results else { return }
        trendingTVs = responseMovies
    }

    func viewDidLoad() {
        view?.configureVC()
        view?.configureSubViews()
        view?.addSubViews()
        view?.configureConstraints()
        view?.configureNavBar()
        Task {
            await fetchPopularMovies()
            await fetchTrendingMovies()
            await fetchUpcomingMovies()
            await fetchTopRatedMovies()
            await fetchTrendingTVs()
        }
    }
}

enum MovieSectionTitles: String, CaseIterable {
    case trendingMovies = "Trending Movies"
    case popular = "Popular"
    case trendingTV = "Trending TV"
    case upcomingMovies = "Upcoming Movies"
    case topRated = "Top Rated"
}
