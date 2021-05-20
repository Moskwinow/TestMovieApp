//
//  TopMoviePresenter.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import Foundation

protocol TopMoviePresenterInput {
    var output: TopMoviePresenterOutput? {get set}
    var model: [Model] {get set}
    var filteringModel: [TypeModel] {get set}
    var isFiltering: Bool {get set}
    func loadData(with type: MovieType)
    func filterContentForSearchText(_ searchText: String)
}

protocol TopMoviePresenterOutput: class {
    func refresh()
}

final class TopMoviePresenter: TopMoviePresenterInput {
    
    weak var output: TopMoviePresenterOutput?
    
    var model: [Model] = [] {
        didSet {
            output?.refresh()
        }
    }
    var filteringModel: [TypeModel] = [] {
        didSet {
            output?.refresh()
        }
    }
    var isFiltering: Bool = false
    
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadData(with type: MovieType) {
        networkService.loadData(type: type) { (result) in
            switch result {
            case .success(let model):
                self.model = model.sorted(by: { (l, r) -> Bool in
                    l.votes > r.votes
                }) as! [Model]
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        isFiltering = !searchText.isEmpty
        filteringModel = model.filter({ (model) -> Bool in
            return (model.title?.lowercased().contains(searchText.lowercased()) ?? false)
        })
    }
}
