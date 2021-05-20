//
//  DetailPresenter.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import Foundation

protocol DetailPresenterInput {
    var model: DetailTypeModel? {get set}
    var reviewModel: [ReviewContent] {get set}
    var id: Int {get set}
    var type: MovieType {get set}
    var output: DetailPresenterOutput? {get set}
    func loadDetailData()
}

protocol DetailPresenterOutput: class {
    func updateView()
    func refresh()
}

final class DetailPresenter: DetailPresenterInput {
    var model: DetailTypeModel? {
        didSet {
            output?.updateView()
        }
    }
    var reviewModel: [ReviewContent] = [] {
        didSet {
            output?.refresh()
        }
    }
    var id: Int
    var type: MovieType
    weak var output: DetailPresenterOutput?
    private var networkService: NetworkService
    
    init(networkService: NetworkService, id: Int, type: MovieType) {
        self.networkService = networkService
        self.id = id
        self.type = type
    }
    
    func loadDetailData() {
        networkService.loadDetailData(type: type, with: id) { [weak self] (result) in
            switch result {
            case .success(let model):
                self?.model = model
                self?.loadReviews(type: self!.type)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadReviews(type: MovieType) {
        networkService.loadReviews(type: type, with: id) { [weak self] (result) in
            switch result {
            case .success(let model):
                self?.reviewModel = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
