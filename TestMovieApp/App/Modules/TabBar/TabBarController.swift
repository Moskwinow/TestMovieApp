//
//  TabBarController.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configurateControllers()
    }
    
    private func configurateControllers() {
        viewControllers = [
            makeTopMovieController(),
            makeTopShowController(),
            makeFavouriteController()
        ]
    }
    
    private func makeTopMovieController() -> UINavigationController {
        let presenter = TopMoviePresenter(networkService: NetworkServiceManager())
        let presentingView = TopMovieController(presenter: presenter)
        let navigation = UINavigationController(rootViewController: presentingView)
        navigation.tabBarItem = UITabBarItem(title: "Top Movies", image: nil, tag: 0)
        presentingView.navigationItem.title = "Top Today"
        presenter.output = presentingView
        return navigation
    }
    
    private func makeTopShowController() -> UINavigationController {
        let presenter = TopShowPresenter(networkService: NetworkServiceManager())
        let presentingView = TopShowController(presenter: presenter)
        let navigation = UINavigationController(rootViewController: presentingView)
        navigation.tabBarItem = UITabBarItem(title: "Top Shows", image: nil, tag: 0)
        presentingView.navigationItem.title = "Top Today"
        presenter.output = presentingView
        return navigation
    }
    private func makeFavouriteController() -> UINavigationController {
        let presenter = FavouritePresenter()
        let presentingView = FavouriteController(presenter: presenter)
        let navigation = UINavigationController(rootViewController: presentingView)
        navigation.tabBarItem = UITabBarItem(title: "Favourites", image: nil, tag: 0)
        presentingView.navigationItem.title = "Favourites"
        presenter.output = presentingView
        return navigation
    }
}
