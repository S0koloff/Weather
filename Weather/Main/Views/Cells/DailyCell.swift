//
//  DailyCell.swift
//  Weather
//
//  Created by Sokolov on 19.03.2024.
//

import UIKit

private extension String {
    static let localeIdentifire = "en_US"
    static let incomingFormat = "yyyy-MM-dd"
    static let requiredFormat = "d MMMM"
}

final class DailyCell: UITableViewCell {
    static let identifire = "DailyCell"
    
    private lazy var detailView: DetailsModel = {
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
        contentView.addSubview(detailView)
        
        detailView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    func configure(icon: Int, name: String, min: Int, max: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: .localeIdentifire)
        dateFormatter.dateFormat = .incomingFormat
        if let date = dateFormatter.date(from: name) {
            dateFormatter.dateFormat = .requiredFormat
            let formattedDate = dateFormatter.string(from: date)
            detailView.setupInfo(imageV: UIImage(named: "\(icon)"), name: formattedDate, stat: "↓ \(min)    ↑ \(max) °C")
        } else {
            print("FormatterError")
        }
    }
}
