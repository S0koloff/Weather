//
//  CurrentDetailsCell.swift
//  Weather
//
//  Created by Sokolov on 20.03.2024.
//

import UIKit
import SnapKit

private extension String {
    static let precipitation = "Precipitation"
    static let wind = "Wind"
    static let humidity = "Humidity"
}

final class CurrentDetailsCell: UITableViewCell {
    
    static let identifire = "CurrentDetailsCell"
    
    private lazy var precipitationView: DetailsModel = {
        let view = DetailsModel()
        return view
    }()
    
    private lazy var windView: DetailsModel = {
        let view = DetailsModel()
        return view
    }()
    
    private lazy var humidityStatView: DetailsModel = {
        let view = DetailsModel()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = Colors.backgroundApp
        contentView.addSubview(precipitationView)
        contentView.addSubview(windView)
        contentView.addSubview(humidityStatView)
        
        precipitationView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(70)
        }
        
        windView.snp.makeConstraints { make in
            make.top.equalTo(precipitationView.snp.bottom).offset(12)
            make.right.left.equalToSuperview()
            make.height.equalTo(70)
        }
        humidityStatView.snp.makeConstraints { make in
            make.top.equalTo(windView.snp.bottom).offset(12)
            make.right.left.equalToSuperview()
            make.height.equalTo(70)
        }
    }
    
    func configure(humidity: Int, windSpeed: Double, precipitation: Double) {
        precipitationView.setupInfo(imageV: Icons.umbrella,
                                    name: .precipitation,
                                    stat: "\(precipitation)cm")
        windView.setupInfo(imageV: Icons.wind,
                           name: .wind,
                           stat: "\(windSpeed)m/s")
        humidityStatView.setupInfo(imageV: Icons.humidity,
                                   name: .humidity,
                                   stat: "\(humidity)%")
        
    }
}
