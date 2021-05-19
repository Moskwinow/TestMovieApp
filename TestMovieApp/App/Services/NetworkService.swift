//
//  NetworkService.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 19.05.2021.
//

import Foundation

enum MovieType: String {
    case movie = "movie"
    case show = "tv"
}

protocol NetworkService {
    func loadData(type: MovieType, completion: @escaping(Result<[TypeModel], Error>) -> ())
}

class NetworkServiceManager: NetworkService {
    private let apiKey = "d4ceb5d78a68bdec35822ba4caf9f655"
    private let contentType = ["Content-Type": "application/json;charset=utf-8"]
    private var stringURL: String {
        "https://api.themoviedb.org/3/trending/"
    }
    
    func loadData(type: MovieType, completion: @escaping (Result<[TypeModel], Error>) -> ()) {
        let url = URL(string: "\(stringURL)\(type.rawValue)/day?api_key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = contentType
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { fatalError("Data undefind") }
            if error == nil {
                guard let model: ResponseModel = try? JSONDecoder().decode(ResponseModel.self, from: data) else {return}
                completion(.success(model.results))
            } else {
                completion(.failure(error!))
            }
        }
        session.resume()
    }
}
