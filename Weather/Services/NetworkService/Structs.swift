//
//  Structs.swift
//  Weather
//
//  Created by Sokolov on 26.03.2024.
//

import Foundation

// MARK: - getLocationInfoFromCityName

struct LocationCoordinates: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String?
}

// MARK: - getLocationInfo

struct LocationInfo: Decodable {
    let name: String
    let country: String
    let state: String
}

// MARK: - getDailyWeather

struct LocationDailyData: Decodable {
    let daily: DailyData
}

struct DailyData: Decodable {
    let data: [DailyDataArray]
}

struct DailyDataArray: Decodable {
    let day: String
    let icon: Int
    let temperature_min: Double
    let temperature_max: Double
}

// MARK: - getHourlyWeather

struct LocationHourlyData: Decodable {
    let hourly: HourlyData
}

struct HourlyData: Decodable {
    let data: [HourlyDataArray]
}

struct HourlyDataArray: Decodable {
    let date: String
    let icon: Int
    let temperature: Double
}

// MARK: - getCurrentWeather

struct LocationData: Decodable {
    let current: CurrentWeather
}

struct CurrentWeather: Decodable {
    let temperature: Double
    let summary: String
    let wind: Wind
    let precipitation: Precipitation
    let humidity: Int
    let icon_num: Int
}

struct Wind: Decodable {
    let speed: Double
}

struct Precipitation: Decodable {
    let total: Double
}
