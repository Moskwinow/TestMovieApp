//
//  UITableView+Ext.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import UIKit.UITableView

extension UITableView {

    func registerCellClass(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable cell for indexPath: \((indexPath.section, indexPath.item))")
        }
        return cell
    }
}
