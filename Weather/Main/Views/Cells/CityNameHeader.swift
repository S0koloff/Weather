//
//  Header.swift
//  Weather
//
//  Created by Sokolov on 19.03.2024.
//

import UIKit

fileprivate enum Constants {
    static let cityNameLabelFont = UIFont.systemFont(ofSize: 28, weight: .semibold)
    static let currentDateFont = UIFont.systemFont(ofSize: 14)
}

final class CityNameHeader: UITableViewHeaderFooterView {
    
    static let identifire = "CityNameHeader"
    
    private lazy var cityNameLabel: UILabel = {
       let cityNameLabel = UILabel()
        cityNameLabel.textColor = Colors.mainDark
        cityNameLabel.font = Constants.cityNameLabelFont
        cityNameLabel.numberOfLines = 0
        return cityNameLabel
    }()
    
    private lazy var currentDate: UILabel = {
       let currentDate = UILabel()
        currentDate.textColor = Colors.secondaryDark
        currentDate.font = Constants.currentDateFont
        return currentDate
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = Colors.backgroundApp
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(currentDate)
        
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(32)
        }
        
        currentDate.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().inset(32)
        }
    }
    
    func configure(name: String) {
        cityNameLabel.text = name
        currentDate.text = Date().toDateString()
    }
}
