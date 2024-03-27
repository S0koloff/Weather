//
//  CurrentDetailsViewModel.swift
//  Weather
//
//  Created by Sokolov on 21.03.2024.
//

import UIKit
import SnapKit

private enum Constants {
        static let backgroundCornerRadius: CGFloat = 15
        static let insets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        static let imageBackgroundSize: CGFloat = 42
        static let imageIconSize: CGFloat = 27
        static let imageIconOffset: CGFloat = 21
        static let labelOffset: CGFloat = 16
        static let statusLabelRightOffset: CGFloat = 28
        static let labelFontSize: CGFloat = 14
        static let labelTextColor = Colors.mainDark
}

final class DetailsModel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundCellView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = Colors.backgroundCell
        backgroundView.layer.cornerRadius = Constants.backgroundCornerRadius
        return backgroundView
    }()
    
    private lazy var backgroundForImage: UIView = {
        let backgroundForImage = UIView()
        backgroundForImage.backgroundColor = Colors.backgroundApp
        backgroundForImage.layer.cornerRadius = Constants.backgroundCornerRadius
        return backgroundForImage
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        nameLabel.textColor = Constants.labelTextColor
        return nameLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        statusLabel.textColor = Constants.labelTextColor
        return statusLabel
    }()
    
    private func setupView() {
        addSubview(backgroundCellView)
        backgroundCellView.addSubview(backgroundForImage)
        backgroundForImage.addSubview(imageView)
        backgroundCellView.addSubview(nameLabel)
        backgroundCellView.addSubview(statusLabel)
    }
    
    private func setupConstraints() {
        backgroundCellView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets)
        }
        
        backgroundForImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.imageIconOffset)
            make.width.height.equalTo(Constants.imageBackgroundSize)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Constants.imageIconSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(backgroundForImage.snp.right).offset(Constants.labelOffset)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Constants.statusLabelRightOffset)
        }
    }
    
    func setupInfo(imageV: UIImage?, name: String?, stat: String?) {
        imageView.image = imageV
        nameLabel.text = name
        statusLabel.text = stat
    }
}
