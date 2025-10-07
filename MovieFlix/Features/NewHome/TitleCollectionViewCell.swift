//
//  TitleCollectionViewCell.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import UIKit

final class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    private let posterImageView = UIImageView()
    private var task: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePosterImageView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        posterImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
}

extension TitleCollectionViewCell {
    func configurePosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        contentView.addSubview(posterImageView)
    }

    func configure(with imagePath: String)  {
        task?.cancel()
        posterImageView.image = nil
        task = Task {
            let movieService = MovieService(networkManager: NetworkManager.shared)
            guard let data = await movieService.fetchMoviePosterImage(path: imagePath) else { return }
            if Task.isCancelled { return }
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.posterImageView.image = UIImage(data: data)
            }
        }
    }
}
