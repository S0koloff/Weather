//
//  CurrentWeatherCell.swift
//  Weather
//
//  Created by Sokolov on 19.03.2024.
//

import UIKit
import SnapKit



final class CurrentCell: UITableViewCell {
    
    static let identifire = "CurrentCell"
    
    private lazy var weatherStatusImage: UIImageView = {
        let weatherStatusImage = UIImageView()
        weatherStatusImage.contentMode = .scaleAspectFill
        return weatherStatusImage
    }()
    
    private lazy var weatherStatusLabel: UILabel = {
        let weatherStatusLabel = UILabel()
        weatherStatusLabel.font = UIFont.systemFont(ofSize: 18)
        weatherStatusLabel.textColor = Colors.secondaryDark
        return weatherStatusLabel
    }()
    
    private lazy var tempLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.boldSystemFont(ofSize: 83)
        tempLabel.textColor = Colors.mainDark
        return tempLabel
    }()
    
    private lazy var celsiusLabel: UILabel = {
        let celsiusLabel = UILabel()
        celsiusLabel.text = "° C"
        celsiusLabel.textColor = Colors.mainDark
        celsiusLabel.font = UIFont.systemFont(ofSize: 16)
        return celsiusLabel
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
        contentView.addSubview(weatherStatusImage)
        contentView.addSubview(weatherStatusLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(celsiusLabel)
        
        weatherStatusImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(contentView.snp.centerX)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherStatusImage.snp.top).inset(15)
            make.left.equalTo(weatherStatusImage.snp.right).offset(20)
            
        }
        
        weatherStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).inset(10)
            make.left.equalTo(weatherStatusImage.snp.right)
        }
        
        celsiusLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherStatusImage.snp.top).inset(20)
            make.left.equalTo(tempLabel.snp.right)
        }
    }
    
    func configure(statusImage: UIImage, weatherStatus: String, temp: Int) {
        weatherStatusImage.image = statusImage
        weatherStatusLabel.text = weatherStatus
        tempLabel.text = String(temp)
    }
}
