//
//  HomeViewController.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import UIKit

protocol HomeViewControllerProtocol: BaseViewControllerProtocol {}

final class HomeViewController: BaseViewController<HomeViewModel> {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var people: [String] = ["Alice", "Bob", "Charlie", "Ece", "Deniz"]

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
    }

    func addSubViews() {
        for item in [tableView] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureTableView() {
        // Cell kaydı (default UITableViewCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.dataSource = self
        tableView.delegate = self

        // Dinamik yükseklik
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56

        let header = UILabel()
        header.text = "Top Header"
        header.textAlignment = .center
        header.frame.size.height = 60

        tableView.tableHeaderView = header

        let footer = UILabel()
        footer.text = "Bottom Footer"
        footer.textAlignment = .center
        footer.frame.size.height = 40
        tableView.tableFooterView = footer

        // Pull to refresh
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addAction(UIAction { [weak self] _ in
            self?.reloadData()
        }, for: .valueChanged)
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
        people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Modern içerik konfigürasyonu (iOS 14+)
        var content = UIListContentConfiguration.cell()
        content.text = person
        content.secondaryText = "Tap for detail"
        content.image = UIImage(systemName: "person.circle")
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = people[indexPath.row]
        let alert = UIAlertController(title: name, message: "Row \(indexPath.row)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // (opsiyonel) kaydır-sil
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let delete = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, done in
            self?.people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func tableView(_ tv: UITableView, titleForHeaderInSection section: Int) -> String? { "Bölüm \(section)" }
    func tableView(_ tv: UITableView, titleForFooterInSection section: Int) -> String? { "Açıklama \(section)" }
}

#Preview {
    HomeViewController()
}
