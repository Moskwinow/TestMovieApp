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
    func loadDetailData(type: MovieType, with id: Int, completion: @escaping(Result<DetailTypeModel, Error>) -> ())
    func loadReviews(type: MovieType, with id: Int, completion: @escaping(Result<[ReviewContent], Error>) -> ())
}

class NetworkServiceManager: NetworkService {
    
    private let apiKey = "d4ceb5d78a68bdec35822ba4caf9f655"
    private let contentType = ["Content-Type": "application/json;charset=utf-8"]
    private var method: String {
        return "GET"
    }
    
    func loadData(type: MovieType, completion: @escaping (Result<[TypeModel], Error>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/trending/\(type.rawValue)/day?api_key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = method
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
    
    func loadDetailData(type: MovieType, with id: Int, completion: @escaping (Result<DetailTypeModel, Error>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/\(type.rawValue)/\(id)?api_key=d4ceb5d78a68bdec35822ba4caf9f655&language=en-US")
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.allHTTPHeaderFields = contentType
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { fatalError("Data undefind") }
            if error == nil {
                guard let model: DetailModel = try? JSONDecoder().decode(DetailModel.self, from: data) else {return}
                completion(.success(model))
            } else {
                completion(.failure(error!))
            }
        }
        session.resume()
    }
    
    func loadReviews(type: MovieType, with id: Int, completion: @escaping(Result<[ReviewContent], Error>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/\(type.rawValue)/\(id)/reviews?api_key=d4ceb5d78a68bdec35822ba4caf9f655&language=en-US&page=1")
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.allHTTPHeaderFields = contentType
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { fatalError("Data undefind") }
            if error == nil {
                guard let model: ReviewModel = try? JSONDecoder().decode(ReviewModel.self, from: data) else {return}
                completion(.success(model.results))
            } else {
                completion(.failure(error!))
            }
        }
        session.resume()
    }
}
