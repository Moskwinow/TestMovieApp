//
//  DetailCell.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import UIKit
import SnapKit
import Kingfisher

class DetailCell: UITableViewCell {
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var posterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private lazy var posterReviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(
            posterImageView,
            posterNameLabel,
            posterReviewLabel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutIfNeeded()
        posterImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 60))
            $0.top.left.equalTo(10)
        }
        posterImageView.layer.cornerRadius = posterImageView.frame.height / 2
        posterImageView.clipsToBounds = true
        posterNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.left.equalTo(posterImageView.snp.right).offset(10)
        }
        posterReviewLabel.snp.makeConstraints {
            $0.top.equalTo(posterNameLabel.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.left.equalTo(posterImageView.snp.right).offset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configurate(with model: ReviewContent) {
        posterNameLabel.text = model.author
        posterReviewLabel.text = model.content
        layoutIfNeeded()
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(model.author_details.avatar_path)") else {return}
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: imageURL)
    }
}
