//
//  HourlyCell.swift
//  Weather
//
//  Created by Sokolov on 19.03.2024.
//

import UIKit

private extension String {
    static let incomingFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static let requiredFormat = "d MMMM HH:mm"
    static let localeIdentifier = "en_US"
}

final class HourlyCell: UITableViewCell {
    static let identifire = "HourlyCell"
    
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
    
    func configure(icon: Int, name: String, value: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: .localeIdentifier)
        dateFormatter.dateFormat = .incomingFormat
        if let date = dateFormatter.date(from: name) {
            dateFormatter.dateFormat = .requiredFormat
            let formattedDate = dateFormatter.string(from: date)
            detailView.setupInfo(imageV: UIImage(named: "\(icon)"), name: formattedDate, stat: "\(value) °C")
        } else {
            print("FormatterError")
        }
    }
}
