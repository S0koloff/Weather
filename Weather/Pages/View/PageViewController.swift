//
//  PsgeViewController.swift
//  Weather
//
//  Created by Sokolov on 25.03.2024.
//

import UIKit
import SnapKit
import CoreLocation
import RxSwift
import RxCocoa

private extension String {
    static let cityTitle = "City"
    static let cityMessage = "Enter the city name"
    static let placeholderText = "Moscow"
    static let closeButton = "Close"
    static let addButton = "Add"
    static let errorTitle = "Error"
    static let errorMessage = "This city is already added to the list."
    static let okButton = "OK"
}

final class PageViewController: UIPageViewController {
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    var viewModel: PageViewModel?
    var pages: [MainViewController] = []
    var pageControl: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        setupPages()
        createNavigationBar()
    }
    
    private func createNavigationBar() {
        let rb = CustomButton().createCustomNavigationButton(imageName: Icons.search,
                                                             action: #selector(searchButtonTapped),
                                                             vc: self)
        
        let searchButton = UIBarButtonItem(customView: rb)
        navigationItem.rightBarButtonItem = searchButton
        
        
        let pageControl = UIPageControl()
        pageControl.backgroundColor = Colors.backgroundApp
        pageControl.currentPageIndicatorTintColor = Colors.mainBlue
        pageControl.pageIndicatorTintColor = Colors.mainDark
        pageControl.numberOfPages = pages.count
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        navigationItem.titleView = pageControl
        
        self.pageControl = pageControl
    }
    
    func setupPages() {
        viewModel?.loadCities()
        
        viewModel?.citiesObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] citiesArray in
                
                for city in citiesArray {
                    guard let isCityAlreadyAdded = self?.pages.contains(where: { $0.viewModel?.latitude == city.latitude && $0.viewModel?.longitude == city.longitude }) else {
                        return
                    }
                    
                    if !isCityAlreadyAdded {
                        let contentVC = MainViewController()
                        contentVC.viewModel = MainViewModel(latitude: city.latitude, longitude: city.longitude)
                        self?.pages.append(contentVC)
                    }
                }
                
                if let firstPage = self?.pages.first {
                    self?.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
                    self?.pageControl?.numberOfPages = self?.pages.count ?? 0
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func searchButtonTapped() {
        let alert = UIAlertController(title: .cityTitle, message: .cityMessage, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = .placeholderText
        }
        
        let cancel = UIAlertAction(title: .closeButton, style: .cancel) { _ in }
        alert.addAction(cancel)
        
        let add = UIAlertAction(title: .addButton, style: .default) { [weak self] _ in
            guard let cityName = alert.textFields?.first?.text, !cityName.isEmpty else { return }
            
            self?.viewModel?.addCity(name: cityName)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { success in
                    if success {
                        self?.setupPages()
                    } else {
                        let duplicateAlert = UIAlertController(title: .errorTitle, message: .errorMessage, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: .okButton, style: .default, handler: nil)
                        duplicateAlert.addAction(okAction)
                        self?.present(duplicateAlert, animated: true, completion: nil)
                    }
                })
                .disposed(by: self!.disposeBag)
        }
        alert.addAction(add)
        
        DispatchQueue.main.async {
            self.setupPages()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        guard let currentIndex = pageControl?.currentPage else {
            return
        }
        if currentIndex < pages.count {
            setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        
        if let currentViewController = pageViewController.viewControllers?.first as? MainViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl?.currentPage = currentIndex
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let contentVC = viewController as? MainViewController,
              let currentIndex = pages.firstIndex(of: contentVC),
              currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let contentVC = viewController as? MainViewController,
              let currentIndex = pages.firstIndex(of: contentVC),
              currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
}

extension PageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var latitude: Double
        var longitude: Double
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            guard let location = locationManager.location else {
                return
            }
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        case .denied, .restricted, .notDetermined:
            latitude = 55.7823547
            longitude = 49.1242266
        @unknown default:
            return
        }
        
        let city = City(name: "", latitude: latitude, longitude: longitude)
        
        viewModel?.loadCities()
        viewModel?.citiesObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] citiesArray in
                if citiesArray.count < 1 {
                    self?.viewModel?.saveCity(city: city)
                }
            }).disposed(by: disposeBag)
        
        setupPages()
    }
}
