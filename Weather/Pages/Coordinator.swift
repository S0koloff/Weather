//
//  Coordinator.swift
//  Weather
//
//  Created by Sokolov on 20.03.2024.
//

import UIKit

final class Coordinator {
    private var navigationController: UINavigationController?
    private let storageService = StorageService.shared
    private let networkService = NetworkService.shared
    
    func start(in window: UIWindow) {
        let viewModel = PageViewModel(storageService: storageService,
                                      networkService: networkService)
        let controller = PageViewController(transitionStyle: .scroll,
                                            navigationOrientation: .horizontal)
        controller.viewModel = viewModel
        
        navigationController = UINavigationController(rootViewController: controller)
        window.backgroundColor = Colors.backgroundApp
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

