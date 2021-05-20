//
//  ReviewModel.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 20.05.2021.
//

import Foundation

struct ReviewModel: Codable {
    var results: [ReviewContent]
}

struct ReviewContent: Codable {
    var author: String
    var author_details: Author
    var content: String
}

struct Author: Codable {
    var avatar_path: String
}
