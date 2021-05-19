//
//  TopShowPresenter.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

protocol TopShowPresenterInput {
    var output: TopShowPresenterOutput? {get set}
    var model: [TypeModel] {get set}
    var filteringModel: [TypeModel] {get set}
    var isFiltering: Bool {get set}
    func loadData(with type: MovieType)
    func filterContentForSearchText(_ searchText: String)
}

protocol TopShowPresenterOutput: class {
    func refresh()
}

final class TopShowPresenter: TopShowPresenterInput {
    
    weak var output: TopShowPresenterOutput?
    
    var model: [TypeModel] = [] {
        didSet {
            output?.refresh()
        }
    }
    var filteringModel: [TypeModel] = [] {
        didSet {
            output?.refresh()
        }
    }
    
    private var networkService: NetworkService
    
    var isFiltering: Bool = false
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadData(with type: MovieType) {
        networkService.loadData(type: type) { (result) in
            switch result {
            case .success(let model):
                self.model = model.sorted(by: { (l, r) -> Bool in
                    l.votes > r.votes
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        isFiltering = !searchText.isEmpty
        filteringModel = model.filter({ (model) -> Bool in
            return (model.name?.lowercased().contains(searchText.lowercased()) ?? false)
        })
    }

}
