//
//  PageViewModel.swift
//  Weather
//
//  Created by Sokolov on 26.03.2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class PageViewModel {
    private let storageService: StorageService?
    private let networkService: NetworkService?
    private var citiesRelay = BehaviorRelay<[City]>(value: [])
    
    var citiesObservable: Observable<[City]> {
        return citiesRelay.asObservable()
    }
    
    init(storageService: StorageService, networkService: NetworkService) {
        self.storageService = storageService
        self.networkService = networkService
    }
    
    func loadCities() {
        guard let citiesArray = storageService?.loadCityArray() else { return }
        citiesRelay.accept(citiesArray)
    }
    
    func addCity(name: String) -> Observable<Bool> {
        guard let networkService = networkService else {
            fatalError("NetworkService is not initialized!")
        }
        
        return networkService.getLocationInfoFromCityName(city: name)
            .map { [weak self] locationCoordinates -> Bool in
                guard let self = self, let getCoord = locationCoordinates?.first else {
                    return false
                }
                
                let coord = City(name: getCoord.name, latitude: getCoord.latitude, longitude: getCoord.longitude)
                
                if self.citiesRelay.value.contains(where: { $0.latitude == getCoord.latitude }) {
                    return false
                } else {
                    self.saveCity(city: coord)
                    var currentCities = self.citiesRelay.value
                    currentCities.append(coord)
                    self.citiesRelay.accept(currentCities)
                    return true
                }
            }
    }
    
    func saveCity(city: City) {
        self.storageService?.saveCity(city)
    }
}
