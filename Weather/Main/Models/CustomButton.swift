//
//  CustomButton.swift
//  Weather
//
//  Created by Sokolov on 22.03.2024.
//

import UIKit

final class CustomButton {
    
    func createCustomNavigationButton(imageName: UIImage?, action: Selector, vc: UIViewController) -> UIButton {
        let button = UIButton()
        button.setImage(imageName?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Colors.mainDark
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(vc, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }
}
