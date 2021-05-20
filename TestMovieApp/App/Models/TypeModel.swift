//
//  TypeModel.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import Foundation

protocol TypeModel: Codable {
    var id: Int {get set}
    var title: String? {get set}
    var votes: Double {get set}
    var overview: String {get set}
    var image: String {get set}
    var name: String? {get set}
    var type: String {get set}
}

