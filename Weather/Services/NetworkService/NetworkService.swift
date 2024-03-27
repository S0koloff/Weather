//
//  NetworkService.swift
//  Weather
//
//  Created by Sokolov on 20.03.2024.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

enum NetworkError: Error {
    case invalidResponse
    case noDataReceived
    case decodingError
    case otherError(description: String)
}

private enum Constants {
    static let headerRapidApiKey = "X-RapidAPI-Key"
    static let headerrapidAPIHost = "X-RapidAPI-Host"
    static let rapidAPIKey = "2df19f6e62msh68736b6ecba425ep106e58jsnc65ff5abf4f7"//"3d815f22e5msh31ebe20761d5985p193775jsn6e0950fbf089"
    static let rapidAPIHostWeather = "ai-weather-by-meteosource.p.rapidapi.com"
    static let rapidAPIHostGeocoding = "geocoding-by-api-ninjas.p.rapidapi.com"
    static let baseURLWeather = "https://ai-weather-by-meteosource.p.rapidapi.com"
    static let baseURLGeocoding = "https://geocoding-by-api-ninjas.p.rapidapi.com"
    static let language = "en"
    static let units = "metric"
    static let timeoutInterval: TimeInterval = 10.0
}

private enum HTTPMethod {
    static let get = "GET"
    static let post = "POST"
}

final class NetworkService {
    static let shared = NetworkService()
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Weather
    
    func getCurrentWeather(lat: Double, lon: Double) -> PublishRelay<LocationData?> {
        let headers = [
            Constants.headerRapidApiKey: Constants.rapidAPIKey,
            Constants.headerrapidAPIHost: Constants.rapidAPIHostWeather
        ]
        
        let url = URL(string: "\(Constants.baseURLWeather)/current?lat=\(lat)&lon=\(lon)&timezone=auto&language=\(Constants.language)&units=\(Constants.units)")!
        
        let request = createRequest(url: url, headers: headers)
        return fetchData(request: request)
    }
    
    func getHourlyWeather(lat: Double, lon: Double) -> PublishRelay<LocationHourlyData?> {
        let headers = [
            Constants.headerRapidApiKey: Constants.rapidAPIKey,
            Constants.headerrapidAPIHost: Constants.rapidAPIHostWeather
        ]
        
        let url = URL(string: "\(Constants.baseURLWeather)/hourly?lat=\(lat)&lon=\(lon)&language=en&units=metric")!
        
        let request = createRequest(url: url, headers: headers)
        return fetchData(request: request)
    }
    
    func getDailyWeather(lat: Double, lon: Double) -> PublishRelay<LocationDailyData?> {
        let headers = [
            Constants.headerRapidApiKey: Constants.rapidAPIKey,
            Constants.headerrapidAPIHost: Constants.rapidAPIHostWeather
        ]
        
        let url = URL(string: "\(Constants.baseURLWeather)/daily?lat=\(lat)&lon=\(lon)&language=en&units=metric")!
        
        let request = createRequest(url: url, headers: headers)
        return fetchData(request: request)
    }
    
    // MARK: - Location
    
    func getLocationInfo(lat: Double, lon: Double) -> PublishRelay<[LocationInfo]?> {
        let headers = [
            Constants.headerRapidApiKey: Constants.rapidAPIKey,
            Constants.headerrapidAPIHost: Constants.rapidAPIHostGeocoding
        ]
        
        let url = URL(string: "\(Constants.baseURLGeocoding)/v1/reversegeocoding?lat=\(lat)&lon=\(lon)")!
        
        let request = createRequest(url: url, headers: headers)
        return fetchData(request: request)
    }
    
    func getLocationInfoFromCityName(city: String) -> PublishRelay<[LocationCoordinates]?> {
        let headers = [
            Constants.headerRapidApiKey: Constants.rapidAPIKey,
            Constants.headerrapidAPIHost: Constants.rapidAPIHostGeocoding
        ]
        
        let url = URL(string: "\(Constants.baseURLGeocoding)/v1/geocoding?city=\(city)")!
        
        let request = createRequest(url: url, headers: headers)
        return fetchData(request: request)
    }
    
    // MARK: - Private Model
    
    private func createRequest(url: URL, headers: [String: String]) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.timeoutInterval)
        request.httpMethod = HTTPMethod.get
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private func fetchData<T: Decodable>(request: URLRequest) -> PublishRelay<T?> {
        let relay = PublishRelay<T?>()
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                relay.accept(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response", (response as? HTTPURLResponse)?.statusCode as Any)
                relay.accept(nil)
                return
            }
            
            guard let data = data else {
                relay.accept(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                relay.accept(decodedData)
            } catch {
                relay.accept(nil)
            }
        }
        task.resume()
        
        return relay
    }
}
