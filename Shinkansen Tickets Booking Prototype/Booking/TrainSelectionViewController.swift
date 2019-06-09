//
//  TrainSelectionViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class TrainSelectionViewController: BookingViewController {
    
    var didFirstLoad: Bool = false
    
    var selectedIndexPath: IndexPath?
    
    var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    var trainCriteria: TrainCriteria? {
        didSet {
            mainTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didFirstLoad {
            
            TrainCriteria.fetchData { [weak self] result in
                if case .success(let trainCriteria) = result {
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.trainCriteria = trainCriteria
                        self?.mainTableView.visibleCells.enumerated().forEach { (index, cell) in
                            guard let cell = cell as? TrainScheduleTableViewCell else { return }
                            cell.preparePropertiesForAnimation()
                            cell.transform.ty = 24 * CGFloat(index)
                            var animationStyle = UIViewAnimationStyle.transitionAnimationStyle
                            animationStyle.duration = 0.05 * TimeInterval(index) + 0.5
                            UIView.animate(withStyle: animationStyle, animations: {
                                cell.setPropertiesToIdentity()
                                cell.transform.ty = 0
                            })
                        }
                        self?.didFirstLoad = true
                        self?.mainTableView.isUserInteractionEnabled = true
                        self?.loadingActivityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        loadingActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        loadingActivityIndicatorView.color = currentColorTheme.componentColor.secondaryText
        loadingActivityIndicatorView.startAnimating()
        mainViewType = .tableView
        mainTableView.isUserInteractionEnabled = false
        mainTableView.addSubview(loadingActivityIndicatorView,
                                 withConstaintEquals: .centerSafeArea)
    }
    
    override func setupInteraction() {
        super.setupInteraction()
        
        backButton.addTarget(self,
                             action: #selector(backButtonDidTouch(_:)),
                             for: .touchUpInside)
    }
    
    private func setupTableView() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(TrainScheduleTableViewCell.self, forCellReuseIdentifier: "TrainScheduleTableViewCell")
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        navigationController?.popViewController(animated: true)
    }
}

extension TrainSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainCriteria?.trainSchedules.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrainScheduleTableViewCell",
                                                       for: indexPath) as? TrainScheduleTableViewCell else { return UITableViewCell() }
        if let trainSchedule = trainCriteria?.trainSchedules[indexPath.row] {
            
            let granClassObject = trainSchedule.seatClasses.first(where: {
                $0.seatClass == .granClass
            })
            
            let greenObject = trainSchedule.seatClasses.first(where: {
                $0.seatClass == .green
            })
            
            let ordinaryObject = trainSchedule.seatClasses.first(where: {
                $0.seatClass == .ordinary
            })
            
            let availableObjects = [granClassObject, greenObject, ordinaryObject].compactMap({$0})
            print(trainSchedule.seatClasses)
            let cheapestPrice = availableObjects.sorted(by: { (classL, classR) -> Bool in
                return classL.price < classR.price
            }).first?.price
            
            
            cell.setupValue(time: "\(trainSchedule.fromTime.time) – \(trainSchedule.toTime.time)",
                    amountOfTime: trainSchedule.toTime.offset(from: trainSchedule.fromTime),
                            trainNumber: trainSchedule.trainNumber,
                            trainName: trainSchedule.trainName,
                            showGranClassIcon: granClassObject != nil,
                            isGranClassAvailable: granClassObject?.isAvailable ?? false,
                            showGreenIcon: greenObject != nil,
                            isGreenAvailable: greenObject?.isAvailable ?? false,
                            showOrdinaryIcon: ordinaryObject != nil,
                            isOrdinaryAvailable: ordinaryObject?.isAvailable ?? false,
                            price: "from \(cheapestPrice?.yen ?? "-")",
                            trainImage: UIImage(named: trainSchedule.trainImageName))
        }
        cell.contentView.alpha = didFirstLoad ? 1 : 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        selectedIndexPath = indexPath
        let trainSchedule = trainCriteria?.trainSchedules[indexPath.row]
        let seatClasses = trainSchedule?.seatClasses
        let seatClassSelectionViewController = SeatClassSelectionViewController()
        seatClassSelectionViewController.seatClasses = seatClasses ?? []
        seatClassSelectionViewController.headerInformation = headerInformation
        seatClassSelectionViewController.headerInformation?.fromTime = trainSchedule?.fromTime.time
        seatClassSelectionViewController.headerInformation?.toTime = trainSchedule?.toTime.time
        seatClassSelectionViewController.headerInformation?.trainNumber = trainSchedule?.trainNumber
        seatClassSelectionViewController.headerInformation?.trainName = trainSchedule?.trainName
        navigationController?.pushViewController(seatClassSelectionViewController, animated: true)
    }
    
}
