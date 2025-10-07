//
//  NewHomeViewController.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import Combine
import UIKit

protocol NewHomeViewControllerProtocol: BaseViewControllerProtocol {
    func configureNavBar()
}

final class NewHomeViewController: UIViewController {
    private let viewModel = NewHomeViewModel()
    let tableView = UITableView(frame: .zero, style: .grouped)
    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
}

extension NewHomeViewController {
    private func configureTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        let tableHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        tableView.tableHeaderView = tableHeaderView

        viewModel.$popularMovies
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &bag)
    }

    func configureNavBar() {
        let netflixImage = UIImageView(image: .netflix)
        netflixImage.contentMode = .scaleAspectFit
        netflixImage.translatesAutoresizingMaskIntoConstraints = false
        netflixImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        netflixImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: netflixImage)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .plain, target: self, action: nil)
        ]
    }
}

extension NewHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        MovieSectionTitles.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0: cell.configure(movies: viewModel.trendingMovies)
        case 1: cell.configure(movies: viewModel.trendingTVs)
        case 2: cell.configure(movies: viewModel.popularMovies)
        case 3: cell.configure(movies: viewModel.upcomingMovies)
        case 4: cell.configure(movies: viewModel.topRatedMovies)
        default:
            break
        }
//        var cfg = UIListContentConfiguration.cell()
//        cfg.text = "Hello World"
//                cell.contentConfiguration = cfg
//        cell.backgroundColor = .green
//        cell.configure(movies: viewModel.popularMovies)
        return cell

//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        var cfg = UIListContentConfiguration.cell()
//        cfg.text = "Hello World"
//        cell.contentConfiguration = cfg
//        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        viewModel.sectionTitles[section]
//    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "  \(MovieSectionTitles.allCases[section].rawValue)"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension NewHomeViewController: NewHomeViewControllerProtocol {
    func configureVC() {}

    func configureSubViews() {
        configureTableView()
    }

    func addSubViews() {
        for item in [tableView] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
}

#Preview {
    MainTabBarViewController()
}
