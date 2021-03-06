//
//  RecentSearchManager.swift
//  Supremo
//
//  Created by Sharad on 14/11/20.
//

import Foundation

enum UserDefaultsKeys {
    
    case recentlyViewed
    case recentSearches
    
    var key: String {
        switch self {
        case .recentlyViewed: return "Supremo-recentlyViewed"
        case .recentSearches: return "Supremo-recentSearches"
        }
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

struct RecentSearchManager<T: Codable> where T : Equatable  {
    
    static func saveCustomObjects(_ object: T, _ key: String) {
        var savedData = RecentSearchManager<T>.getCustomObjects(key)
        if !savedData.contains(obj: object) {
            savedData.append(object)
        } else {
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(savedData)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
    static func getCustomObjects(_ key: String) -> [T] {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([T].self, from: data)
                return decoded
            } catch {
                print("Unable to Decode Notes (\(error))")
                return [T]()
            }
        }
        return [T]()
    }
}
