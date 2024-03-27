//
//  HourlyDailyHeader.swift
//  Weather
//
//  Created by Sokolov on 19.03.2024.
//

import UIKit
import SnapKit

protocol HourlyDailyHeaderDelegate {
    func tap()
}

fileprivate enum Constants {
    static let labelFontSize: CGFloat = 16
}

private extension String {
    static let todayLabeltext = "Today"
    static let nextDaysLabeltext = "Next 7 Days"
}

final class HourlyDailyHeader: UITableViewHeaderFooterView {
    
    static let identifire = "HourlyDailyHeader"
    
    var delegate: HourlyDailyHeaderDelegate!
    
    private lazy var todayLabel: UILabel = {
        let todayLabel = UILabel()
        todayLabel.text = .todayLabeltext
        todayLabel.textColor = Colors.mainBlue
        todayLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        return todayLabel
    }()
    
    private lazy var nextDaysLabel: UILabel = {
        let nextDaysLabel = UILabel()
        nextDaysLabel.text = .nextDaysLabeltext
        nextDaysLabel.textColor = Colors.mainBlue
        nextDaysLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        return nextDaysLabel
    }()
    
    private lazy var blueLineImage: UIImageView = {
        let blueLineImage = UIImageView()
        blueLineImage.image = Icons.blueLine
        return blueLineImage
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(todayLabel)
        contentView.addSubview(nextDaysLabel)
        contentView.addSubview(blueLineImage)
        
        todayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(5)
        }
        
        nextDaysLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(32)
            make.top.equalToSuperview().offset(5)
        }
        
        blueLineImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    private func setupGesture() {
        let tapGestureR = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let tapGestureL = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        todayLabel.isUserInteractionEnabled = true
        nextDaysLabel.isUserInteractionEnabled = true
        todayLabel.addGestureRecognizer(tapGestureL)
        nextDaysLabel.addGestureRecognizer(tapGestureR)
    }
    
    func setupSelected(switchBool: Bool) {
        if switchBool == true {
            nextDaysLabel.textColor = Colors.mainBlue
            nextDaysLabel.font = .boldSystemFont(ofSize: Constants.labelFontSize)
            todayLabel.textColor = Colors.mainDark
            todayLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        } else {
            todayLabel.textColor = Colors.mainBlue
            todayLabel.font = .boldSystemFont(ofSize: Constants.labelFontSize)
            nextDaysLabel.textColor = Colors.mainDark
            nextDaysLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        delegate.tap()
    }
}
