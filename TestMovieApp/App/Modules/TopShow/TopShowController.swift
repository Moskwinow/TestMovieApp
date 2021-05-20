//
//  TopShowController.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import UIKit

class TopShowController: UIViewController {
    
    var presenter: TopShowPresenterInput
    var favourites: [Model] = DefaultServiceManager.fetchFavourites() {
        willSet {
            DefaultServiceManager.saveItem(model: newValue)
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Top"
        return searchController
    }()
    
    private lazy var tableView: BrandTableView = {
        let table = BrandTableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.registerCellClass(BrandCell.self)
        return table
    }()
    
    // MARK: -  Life Cycle
    
    init(presenter: TopShowPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        view.addSubviews(tableView)
        presenter.loadData(with: .show)
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
        favourites = DefaultServiceManager.fetchFavourites()
        tableView.reloadData()
    }
    
    private func performToDetail(type: MovieType, id: Int) {
        let presenter = DetailPresenter(networkService: NetworkServiceManager(), id: id, type: type)
        let presentingView = DetailController(presenter: presenter)
        presenter.output = presentingView
        self.navigationController?.pushViewController(presentingView, animated: true)
    }
}

// MARK: -  Table view data source

extension TopShowController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.isFiltering {
            return presenter.filteringModel.count
        } else {
            return presenter.model.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BrandCell = tableView.dequeueReusableCell(for: indexPath)
        var model: [TypeModel] = []
        if presenter.isFiltering {
            model = presenter.filteringModel
        } else {
            model = presenter.model
        }
        cell.configurate(with: model[indexPath.row])
        if favourites.contains(where: {$0.id == model[indexPath.row].id}) {
            cell.fillHeart = true
        } else {
            cell.fillHeart = false
        }
        cell.heartIsSelected = { [ weak self] in
            guard let self = self  else {return}
            if !self.favourites.contains(where: {$0.id == model[indexPath.row].id}) {
                self.favourites.append(model[indexPath.row] as! Model)
                DefaultServiceManager.saveItem(model: self.favourites)
                cell.fillHeart.toggle()
            } else {
                guard let index = self.favourites.firstIndex(where: {$0.id == model[indexPath.row].id}) else {return}
                self.favourites.remove(at: index)
                DefaultServiceManager.saveItem(model: self.favourites)
                cell.fillHeart.toggle()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter.isFiltering {
            performToDetail(type: .show, id: presenter.filteringModel[indexPath.row].id)
        } else {
            performToDetail(type: .show, id: presenter.model[indexPath.row].id)
        }
    }
}

extension TopShowController: TopShowPresenterOutput {
    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TopShowController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        presenter.filterContentForSearchText(searchText)
    }
}
