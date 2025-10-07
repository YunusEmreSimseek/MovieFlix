//
//  CollectionTableViewCell.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import UIKit

final class CollectionTableViewCell: UITableViewCell {
    static let identifier = "CollectionTableViewCell"

    private lazy var collectionView: UICollectionView = configureCollectionView()
    private var movies: [Movie] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureVC()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionTableViewCell {
    func configureVC() {
        contentView.backgroundColor = .blue
    }

    func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }

    func configure(movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
    }
}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let path = movies[indexPath.item].posterPath else { return cell }
        cell.configure(with: path)
//        Task { await cell.configure(path: movies[indexPath.row].posterPath ?? "") }
        cell.backgroundColor = .brown
        return cell
    }
}
