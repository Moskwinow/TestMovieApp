//
//  FavouriteController.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 20.05.2021.
//

import UIKit

class FavouriteController: UIViewController {
    
    var presenter: FavouritePresenterInput
    
    private lazy var tableView: BrandTableView = {
        let table = BrandTableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.registerCellClass(BrandCell.self)
        return table
    }()

    // MARK: -  Life Cycle
    
    init(presenter: FavouritePresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        presenter.updateUI()
    }
    
    private func performToDetail(type: MovieType, id: Int) {
        let presenter = DetailPresenter(networkService: NetworkServiceManager(), id: id, type: type)
        let presentingView = DetailController(presenter: presenter)
        presenter.output = presentingView
        self.navigationController?.pushViewController(presentingView, animated: true)
    }

}

extension FavouriteController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BrandCell = tableView.dequeueReusableCell(for: indexPath)
        guard var model = presenter.model else {return cell}
        cell.configurate(with: model[indexPath.row])
        cell.heartIsSelected = { [weak self] in
            guard let self = self else {return}
            model.remove(at: indexPath.row)
            DefaultServiceManager.saveItem(model: model as! [Model])
            self.presenter.updateUI()
        }
        cell.fillHeart = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = presenter.model else {return}
        performToDetail(type: MovieType(rawValue: model[indexPath.row].type) ?? .movie, id: model[indexPath.row].id)
    }
}

extension FavouriteController: FavouritePresenterOutput {
    func refresh() {
        tableView.reloadData()
    }
}
