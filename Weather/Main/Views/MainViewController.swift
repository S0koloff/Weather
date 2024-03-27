//
//  MainViewController.swift
//  Weather
//
//  Created by Sokolov on 19.03.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityNameHeader.self, forHeaderFooterViewReuseIdentifier: CityNameHeader.identifire)
        tableView.register(CurrentCell.self, forCellReuseIdentifier: CurrentCell.identifire)
        tableView.register(CurrentDetailsCell.self, forCellReuseIdentifier: CurrentDetailsCell.identifire)
        tableView.register(HourlyDailyHeader.self, forHeaderFooterViewReuseIdentifier: HourlyDailyHeader.identifire)
        tableView.register(HourlyCell.self, forCellReuseIdentifier: HourlyCell.identifire)
        tableView.register(DailyCell.self, forCellReuseIdentifier: DailyCell.identifire)
        tableView.separatorStyle = .none
        tableView.alpha = 0
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundApp
        
        setupView()
    }
    
    private func setupView() {
        
        view.addSubview(tableView)
        
        UIView.animate(withDuration: 1.5) {
            self.tableView.alpha = 1
        }
        
        let guide = view.safeAreaLayoutGuide
        tableView.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.bottom.left.right.equalToSuperview()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            guard let switchHourlyDaily = viewModel?.switchHourlyDaily.value else {
                return 25
            }
            return switchHourlyDaily ? 7 : 25
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrentCell.identifire, for: indexPath) as! CurrentCell
            viewModel?.getCurrentWeather()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { weather in
                    if let weather = weather {
                        cell.configure(statusImage: weather.icon,
                                       weatherStatus: weather.summary,
                                       temp: Int(weather.temperature))
                    } else {
                        return
                    }
                }).disposed(by: disposeBag)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrentDetailsCell.identifire, for: indexPath) as! CurrentDetailsCell
            viewModel?.getCurrentWeather()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { weather in
                    if let weather = weather {
                    cell.configure(humidity: weather.humidity,
                                   windSpeed: weather.windSpeed,
                                   precipitation: weather.precipitation)
                } else {
                    return
                }
                }).disposed(by: disposeBag)
            return cell
        } else {
            guard let switchHourlyDaily = viewModel?.switchHourlyDaily else {
                let cell = tableView.dequeueReusableCell(withIdentifier: HourlyCell.identifire, for: indexPath) as! HourlyCell
                viewModel?.getHourlyWeather()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { hourlyArray in
                        
                    guard let array = hourlyArray?[indexPath.row] else {
                        return
                    }
                    cell.configure(icon: array.icon,
                                   name: array.date,
                                   value: Int(array.temperature))
                    }).disposed(by: disposeBag)
                return cell
            }
            
            if switchHourlyDaily.value == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: DailyCell.identifire, for: indexPath) as! DailyCell
                viewModel?.getDailyWeather()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { dailyArray in
                        guard let array = dailyArray?[indexPath.row] else {
                            return
                        }
                        cell.configure(icon: array.icon,
                                       name: array.day,
                                       min: Int(array.temperature_min),
                                       max: Int(array.temperature_max))
                    }).disposed(by: disposeBag)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: HourlyCell.identifire, for: indexPath) as! HourlyCell
                viewModel?.getHourlyWeather()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { hourlyArray in
                        
                    guard let array = hourlyArray?[indexPath.row] else {
                        return
                    }
                    cell.configure(icon: array.icon,
                                   name: array.date,
                                   value: Int(array.temperature))
                    }).disposed(by: disposeBag)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: CityNameHeader.identifire) as! CityNameHeader
            viewModel?.getLocationInfo()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { location in
                if let location = location {
                    header.configure(name: location.name)
                } else {
                    return
                }
                }).disposed(by: disposeBag)
            return header
        } else {
            if section == 2 {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HourlyDailyHeader.identifire) as! HourlyDailyHeader
                header.delegate = self
                guard let switchBool = viewModel?.switchHourlyDaily.value else {
                    return header
                }
                header.setupSelected(switchBool: switchBool)
                return header
            } else {
                return nil
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == .zero {
            return 150
        } else if indexPath.section == 1 {
            return 240
        } else {
            return 82
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 70
        } else if section == 2 {
            return 50
        } else {
            return 1
        }
    }
}

extension MainViewController: UITableViewDelegate {
}

extension MainViewController: HourlyDailyHeaderDelegate {
    func tap() {
        guard let switchHourlyDaily = viewModel?.switchHourlyDaily.value else {
            return
        }
        
        if switchHourlyDaily == true {
            viewModel?.switchHourlyDaily(getBool: false)
            tableView.reloadData()
        } else {
            viewModel?.switchHourlyDaily(getBool: true)
            tableView.reloadData()
        }
    }
}
