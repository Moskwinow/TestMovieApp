//
//  FavouritePresenter.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 20.05.2021.
//

import Foundation

protocol FavouritePresenterInput {
    var output: FavouritePresenterOutput? {get set}
    var model: [TypeModel]? {get set}
    func updateUI()
}

protocol FavouritePresenterOutput: class {
    func refresh()
}

final class FavouritePresenter: FavouritePresenterInput {
    weak var output: FavouritePresenterOutput?
    var model: [TypeModel]? = [] {
        didSet {
            output?.refresh()
        }
    }
    
    func updateUI() {
        self.model = DefaultServiceManager.fetchFavourites()
        output?.refresh()
    }
}
