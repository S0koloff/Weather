//
//  MainViewModel.swift
//  Weather
//
//  Created by Sokolov on 20.03.2024.
//

import UIKit
import RxSwift
import RxRelay

private extension String {
    static let locationAuthorizedKey = "locationAuthorizedKey"
}

final class MainViewModel {
    
    private let networkService = NetworkService.shared
    var switchHourlyDaily = BehaviorRelay<Bool>(value: false)
    var latitude: Double
    var longitude : Double // Kazan 55.796391  49.108891 for test
    
    init(latitude: Double, longitude: Double) {
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getLocation(lat: Double, lon: Double) {
        latitude = lat
        longitude = lon
    }
    
    func getCurrentWeather() -> Observable<Weather?> {
        return networkService.getCurrentWeather(lat: latitude, lon: longitude)
            .observe(on: MainScheduler.instance)
            .map { locationData -> Weather? in
                guard let locationData = locationData else {
                    return nil
                }
                let currentWeather = Weather(icon: (UIImage(named: "\(locationData.current.icon_num)") ?? UIImage(named: "1"))!,
                                             temperature: locationData.current.temperature,
                                             summary: locationData.current.summary,
                                             windSpeed: locationData.current.wind.speed,
                                             precipitation: locationData.current.precipitation.total,
                                             humidity: locationData.current.humidity)
                return currentWeather
            }
    }
    
    func getLocationInfo() -> Observable<LocationInfo?> {
        return networkService.getLocationInfo(lat: latitude, lon: longitude)
            .observe(on: MainScheduler.instance)
            .map { locationInfo in
                guard let locationInfo = locationInfo else {
                    return nil
                }
                
                guard let locationInfoF = locationInfo.first else {
                    return nil
                }
                
                let location = LocationInfo(name: locationInfoF.name,
                                            country: locationInfoF.country,
                                            state: locationInfoF.state)
                return location
            }
    }
    
    
    func getHourlyWeather() -> Observable<[HourlyDataArray]?> {
        return networkService.getHourlyWeather(lat: latitude, lon: longitude)
            .observe(on: MainScheduler.instance)
            .map { locationHourlyData -> [HourlyDataArray]? in
                return locationHourlyData?.hourly.data
            }
    }
    
    func getDailyWeather() -> Observable<[DailyDataArray]?> {
        return networkService.getDailyWeather(lat: latitude, lon: longitude)
            .observe(on: MainScheduler.instance)
            .map { locationDailyData -> [DailyDataArray]? in
                return locationDailyData?.daily.data
            }
    }
    
    func switchHourlyDaily(getBool: Bool) {
        switchHourlyDaily.accept(getBool)
    }
    
    func getHourlyDaily() -> Bool {
        return switchHourlyDaily.value
    }
}
