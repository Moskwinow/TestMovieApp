//
//  MovieModel.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import Foundation

struct ResponseModel: Decodable {
    var page: Int
    var results: [Model]
}

struct Model: TypeModel, Codable, Equatable {
    
    var id: Int = 0
    
    var title: String? = ""
    
    var votes: Double = 0.0
    
    var overview: String = ""
    
    var image: String = ""
    
    var name: String?
    
    var type: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case votes = "vote_average"
        case title = "original_title"
        case id = "id"
        case overview = "overview"
        case image = "poster_path"
        case type = "media_type"
        case name = "name"
    }
}
