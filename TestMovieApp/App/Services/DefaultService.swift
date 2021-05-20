//
//  DefaultService.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 20.05.2021.
//

import Foundation

class DefaultServiceManager {
   private static let key = "favourites.key.app"
    
    static func fetchFavourites() -> [Model] {
        let decoder = JSONDecoder()
        if let modelData = UserDefaults.standard.object(forKey: key) as? Data {
            if let loadedModel = try? decoder.decode([Model].self, from: modelData) {
                return loadedModel
            }
        }
        return  []
    }
    
    static func saveItem(model: [Model]) {
        let jsonEndcoder = JSONEncoder()
        if let encoded = try? jsonEndcoder.encode(model) {
            UserDefaults.standard.setValue(encoded, forKey: key)
        }
    }
    
    static func deleteItem(model: Model) {
        var modelArray = fetchFavourites()
        guard let index = modelArray.firstIndex(where: {$0.id == model.id}) else {return}
        modelArray.remove(at: index)
    }
}
