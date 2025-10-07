//
//  HeroHeaderView.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import UIKit

final class HeroHeaderView: UIView {
    private let heroImageView = UIImageView()
    private let playButton = UIButton()
    private let downloadButton = UIButton()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHeroImageView()
        configureGradientLayer()
        configurePlayButton()
        configureDownloadButton()
        configureConstraints()
    }

    override func layoutSubviews() {
        heroImageView.frame = bounds
        gradientLayer.frame = bounds
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeroHeaderView {
    private func configurePlayButton() {
        var cfg = UIButton.Configuration.plain()
        cfg.title = "Play"
        cfg.background.cornerRadius = 8
        playButton.configuration = cfg
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 1
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)
    }

    private func configureHeroImageView() {
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.image = UIImage(resource: ._300)
        addSubview(heroImageView)
    }

    private func configureGradientLayer() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor,
        ]
        layer.addSublayer(gradientLayer)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 106),

            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 106),

        ])
    }

    private func configureDownloadButton() {
        var cfg = UIButton.Configuration.plain()
        cfg.title = "Download"
        cfg.background.cornerRadius = 8
        downloadButton.configuration = cfg
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.borderWidth = 1
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(downloadButton)
    }
}
