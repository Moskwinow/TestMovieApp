//
//  BrandCell.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import UIKit
import Kingfisher

class BrandCell: UITableViewCell {
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "movie")
        return imageView
    }()
    
    private lazy var movieNameTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "fgdshjgfhjds"
        return label
    }()
    
    private lazy var movieDescriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .black
        label.text = "fgdshjgfhjds"
        return label
    }()
    
    private lazy var movieRateTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .lightGray
        label.text = "fgdshjgfhjds"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubviews(
            movieImageView,
            movieNameTextLabel,
            movieDescriptionTextLabel,
            movieRateTextLabel
        )
        layoutIfNeeded()
        setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 80))
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(15)
        }
        movieNameTextLabel.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(10)
            $0.left.equalTo(movieImageView.snp.right).offset(10)
        }
        movieDescriptionTextLabel.snp.makeConstraints {
            $0.left.equalTo(movieImageView.snp.right).offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(movieNameTextLabel.snp.bottom).offset(8)
        }
        movieRateTextLabel.snp.makeConstraints {
            $0.left.equalTo(movieImageView.snp.right).offset(10)
            $0.top.equalTo(movieDescriptionTextLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configurate(with model: TypeModel) {
        if model.type == "tv" {
            movieNameTextLabel.text = model.name
        } else {
            movieNameTextLabel.text = model.title
        }
        movieDescriptionTextLabel.text = model.overview
        movieRateTextLabel.text = "Rate: \(model.votes)"
        layoutIfNeeded()
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(model.image)") else {return}
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(with: imageURL)
    }
}
