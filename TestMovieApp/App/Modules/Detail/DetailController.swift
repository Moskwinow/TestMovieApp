//
//  DetailController.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import UIKit
import SnapKit

class DetailController: UIViewController {
    
    var presenter: DetailPresenterInput
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var movieTitleTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private lazy var genresTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    private lazy var movieOverviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rateTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var tableView: BrandTableView = {
        let table = BrandTableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.registerCellClass(DetailCell.self)
        return table
    }()
    
    // MARK: -  Life cycle
    
    init(presenter: DetailPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(
            posterImageView,
            movieTitleTextLabel,
            genresTextLabel,
            movieOverviewTextLabel,
            rateTextLabel,
            tableView
        )
        presenter.loadDetailData()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        posterImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 180))
            $0.top.equalToSuperview().inset(100)
            $0.left.equalToSuperview().inset(15)
        }
        movieTitleTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.right.equalToSuperview().inset(-10)
            $0.left.equalTo(posterImageView.snp.right).offset(20)
        }
        genresTextLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleTextLabel.snp.bottom).offset(8)
            $0.left.equalTo(posterImageView.snp.right).offset(20)
            $0.right.equalToSuperview().inset(-10)
        }
        rateTextLabel.snp.makeConstraints {
            $0.left.equalTo(posterImageView.snp.right).offset(20)
            $0.right.equalToSuperview().inset(-10)
            $0.top.equalTo(genresTextLabel.snp.bottom).offset(8)
        }
        movieOverviewTextLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(10)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(movieOverviewTextLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview().inset(0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: -  Table view data source

extension DetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.reviewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configurate(with: presenter.reviewModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
}


extension DetailController: DetailPresenterOutput {
    func updateView() {
        DispatchQueue.main.async {
            if self.presenter.type == .movie {
                self.movieTitleTextLabel.text = self.presenter.model?.title
            } else {
                self.movieTitleTextLabel.text = self.presenter.model?.name
            }
            for genre in self.presenter.model?.genres ?? [] {
                self.genresTextLabel.text = "\(genre.name) "
            }
            self.rateTextLabel.text = "Rate: \(self.presenter.model?.votes ?? 0.0)"
            self.movieOverviewTextLabel.text = self.presenter.model?.overview
            guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(self.presenter.model?.image ?? "")") else {return}
            self.posterImageView.kf.indicatorType = .activity
            self.posterImageView.kf.setImage(with: imageURL)
        }
    }
    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
