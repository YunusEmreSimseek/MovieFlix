//
//  MovieCell.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import UIKit

final class MovieCell: UITableViewCell {
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .secondarySystemFill // placeholder arkaplan
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .headline)
        l.numberOfLines = 2
        return l
    }()

    private let overviewLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .subheadline)
        l.textColor = .secondaryLabel
        l.numberOfLines = 2 // 2-3 satır tutmak iyi olur
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .footnote)
        l.textColor = .tertiaryLabel
        return l
    }()

    // Sağ blok: title + overview + date (dikey)
    private lazy var rightVStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [titleLabel, overviewLabel, dateLabel])
        s.axis = .vertical
        s.spacing = 6
        return s
    }()

    // Solda poster, sağda bilgiler (yatay)
    private lazy var rootHStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [posterImageView, rightVStack])
        s.axis = .horizontal
        s.alignment = .top
        s.spacing = 12
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    // async image task (cancel için)
    private var imageTask: Task<Void, Never>?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        contentView.addSubview(rootHStack)

        // Poster sabit boyut
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),

            rootHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rootHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rootHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rootHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])

        // Label’ların sıkışma/hugging öncelikleri (title kolay kolay kesilmesin)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        overviewLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        posterImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        dateLabel.text = nil
    }

    // MARK: - Configure

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        dateLabel.text = movie._releaseDate

        // Görseli yükle
        if let url = movie.posterPath {
//            loadImage(url)
        }
    }

    private func loadImage(_ url: URL) {
        // Basit async/await yükleme (cache’li istersen NSCache ekleyebilirsin)
        imageTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if Task.isCancelled { return }
                if let img = UIImage(data: data) {
                    // UI güncellemesi ana thread
                    await MainActor.run { [weak self] in
                        self?.posterImageView.image = img
                    }
                }
            } catch {
                // Hata durumunda placeholder kalır
            }
        }
    }
}
