//
//  TopShowController.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import UIKit

class TopShowController: UIViewController {
    
    var presenter: TopShowPresenterInput
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Top"
        return searchController
    }()
    
    private lazy var tableView: BrandTableView = {
        let table = BrandTableView(frame: .zero, style: .plain)
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.tableFooterView = .init(frame: .zero)
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
        tableView.dataSource = self
        tableView.delegate = self
        presenter.loadData(with: .show)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
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
        if presenter.isFiltering {
            cell.configurate(with: presenter.filteringModel[indexPath.row])
        } else {
            cell.configurate(with: presenter.model[indexPath.row])
        }
        return cell
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
