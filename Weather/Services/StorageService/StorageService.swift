//
//  StorageService.swift
//  Weather
//
//  Created by Sokolov on 25.03.2024.
//

import Foundation

final class StorageService {
    static let shared = StorageService()
    private init() {}
    
    private let key = "cities"
    
    func saveCity(_ city: City) {
        var cities = loadCityArray() ?? []
        cities.append(city)
        saveCities(cities)
    }
    
    private func saveCities(_ cities: [City]) {
        let data = try? JSONEncoder().encode(cities)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func loadCityArray() -> [City]? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else {
            return nil
        }
        
        let cities = try? JSONDecoder().decode([City].self, from: data)
        return cities
    }
}
