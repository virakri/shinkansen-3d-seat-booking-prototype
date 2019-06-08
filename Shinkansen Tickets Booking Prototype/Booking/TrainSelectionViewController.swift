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
    
    var trainCriteria: TrainCriteria?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didFirstLoad {
            
            TrainCriteria.fetchData { [weak self] result in
                if case .success(let trainCriteria) = result {
                    self?.trainCriteria = trainCriteria
                    DispatchQueue.main.async {
                        [weak self] in
                        
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrainScheduleTableViewCell",
                                                       for: indexPath) as? TrainScheduleTableViewCell else { return UITableViewCell() }
        
        cell.setupValue(time: "12:12",
                        amountOfTime: "5hr 21m",
                        trainNumber: "Hayabusa 8",
                        trainName: "E7 Series",
                        isGranClassAvailable: true,
                        isGreenAvailable: true,
                        isOrdinaryAvailable: true,
                        price: "from $9,000",
                        trainImage: nil)
        cell.contentView.alpha = didFirstLoad ? 1 : 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        selectedIndexPath = indexPath
        let seatClassSelectionViewController = SeatClassSelectionViewController()
        seatClassSelectionViewController.headerInformation = headerInformation
        seatClassSelectionViewController.headerInformation?.fromTime = "8:42"
        seatClassSelectionViewController.headerInformation?.toTime = "11:23"
        seatClassSelectionViewController.headerInformation?.trainNumber = "Hayabusa 14"
        seatClassSelectionViewController.headerInformation?.trainName = "E6 Series"
        navigationController?.pushViewController(seatClassSelectionViewController, animated: true)
    }
    
}
