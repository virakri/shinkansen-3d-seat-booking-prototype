//
//  SeatClassSelectionViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class SeatClassSelectionViewController: BookingViewController {
    
    var selectedIndexPath: IndexPath?
    
    var seatMap: SeatMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func setupView() {
        super.setupView()
        mainViewType = .tableView
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
        mainTableView.register(SeatClassTableViewCell.self, forCellReuseIdentifier: "SeatClassTableViewCell")
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        navigationController?.popViewController(animated: true)
    }
}

extension SeatClassSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeatClassTableViewCell",
                                                       for: indexPath) as? SeatClassTableViewCell else { return UITableViewCell() }
        
        cell.setupValue(seatClass: .granClass,
                        seatClassName: "Green Car",
                        price: "$14,320",
                        description: "a first class travel with an experience of luxury ",
                        trainImage: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        selectedIndexPath = indexPath
        
        // TODO: Fix this
        let selectedEntity = seatMap?.seatClassEntities.first(where: {
            $0.seatClass == .granClass
        })
        
        let seatMapSelectionViewController = SeatMapSelectionViewController()
        seatMapSelectionViewController.seatEntity = selectedEntity
        seatMapSelectionViewController.headerInformation = headerInformation
        seatMapSelectionViewController.headerInformation?.carNumber = selectedEntity?.carNumber
        seatMapSelectionViewController.headerInformation?.className = selectedEntity?.seatClass.name
        seatMapSelectionViewController.headerInformation?.price = "¥14,230"
        navigationController?.pushViewController(seatMapSelectionViewController, animated: true)
    }
    
}
