//
//  HomeViewController.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import Combine
import UIKit

protocol HomeViewControllerProtocol: BaseViewControllerProtocol {}

final class HomeViewController: BaseViewController<HomeViewModel> {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let bottomButton = UIButton(type: .system)
    private var bag = Set<AnyCancellable>()

    init() { super.init(viewModel: HomeViewModel()) }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func configureVC() {}

    func configureSubViews() {
        configureTableView()
        configureBottomButton()
    }

    func addSubViews() {
        for item in [tableView, bottomButton] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),

            bottomButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)

        ])
    }

    private func configureTableView() {
        // Cell kaydı (default UITableViewCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        viewModel.$movies
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &bag)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGroupedBackground

        // Dinamik yükseklik
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56

        let header = UILabel()
        header.text = "Most Popular Movies"
        header.textAlignment = .center
        header.frame.size.height = 60
        header.font = .boldSystemFont(ofSize: 24)

        tableView.tableHeaderView = header

        // Pull to refresh
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addAction(UIAction { [weak self] _ in
            self?.reloadData()
        }, for: .valueChanged)
    }

    private func configureBottomButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Bottom Button"
        config.background.cornerRadius = 8
        bottomButton.configuration = config

        bottomButton.addAction(UIAction { _ in
            Task { await self.viewModel.fetchPopularMovies() }

        }, for: .touchUpInside)
    }

    private func reloadData() {
        // burada normalde network çağrısı olur
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Modern içerik konfigürasyonu (iOS 14+)
        var content = UIListContentConfiguration.cell()
        content.text = movie._title
        content.secondaryText = movie._releaseDate
        content.image = UIImage(systemName: "person.circle")
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.movies[indexPath.row]
        viewModel.navigateToMovieDetail(movie: movie)
//        Task { await viewModel.fetchPopularMovies() }
//        let name = people[indexPath.row]
//        let alert = UIAlertController(title: name, message: "Row \(indexPath.row)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
    }

    // (opsiyonel) kaydır-sil
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let delete = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, done in
            guard let self = self else { return }
            self.viewModel.movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }

//    func tableView(_ tv: UITableView, titleForHeaderInSection section: Int) -> String? { "Bölüm \(section)" }
//    func tableView(_ tv: UITableView, titleForFooterInSection section: Int) -> String? { "Açıklama \(section)" }
}

#Preview {
    HomeViewController()
}
