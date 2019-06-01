//
//  TrainSelectionViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class TrainSelectionViewController: BookingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func setupView() {
        super.setupView()
        mainViewType = .tableView
        mainCallToActionButton.isHidden = true
        
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
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        navigationController?.pushViewController(SeatClassSelectionViewController(), animated: true)
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        navigationController?.popViewController(animated: true)
    }
}

extension TrainSelectionViewController: UITableViewDelegate, UITableViewDataSource {
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
        return cell
    }
    
    
}
