//
//  DetailModel.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import Foundation

struct DetailModel: DetailTypeModel, Decodable {
    var id: Int
    
    var name: String?
    
    var title: String?
    
    var genres: [Genres]?
    
    var overview: String
    
    var image: String
    
    var votes: Double
    
    private enum CodingKeys: String, CodingKey {
        case votes = "vote_average"
        case title = "original_title"
        case id = "id"
        case overview = "overview"
        case image = "poster_path"
        case name = "name"
        case genres = "genres"
    }
}
