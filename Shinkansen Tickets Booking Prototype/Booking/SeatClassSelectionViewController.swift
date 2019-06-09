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
    
    var seatClasses: [SeatClass] = []
    
    var seatMap: SeatMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        SeatMap.fetchData { result in
            if case .success(let seatMap) = result {
                self.seatMap = seatMap
            }
        }
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
        return seatClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeatClassTableViewCell",
                                                       for: indexPath) as? SeatClassTableViewCell else { return UITableViewCell() }
        let seatClass = seatClasses[indexPath.row]
        
        cell.setupValue(seatClassType: seatClass.seatClass,
                        seatClassName: seatClass.name,
                        price: seatClass.price.yen,
                        description: seatClass.description,
                        seatImage: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        selectedIndexPath = indexPath
        
        let seatClass = seatClasses[indexPath.row]
        
        let selectedEntity = seatMap?.seatClassEntities.first(where: {
            $0.seatClass == seatClass.seatClass
        })
        
        let seatMapSelectionViewController = SeatMapSelectionViewController()
        seatMapSelectionViewController.seatClass = seatClass
        seatMapSelectionViewController.seatClassEntity = selectedEntity
        seatMapSelectionViewController.headerInformation = headerInformation
        seatMapSelectionViewController.headerInformation?.carNumber = selectedEntity?.carNumber
        seatMapSelectionViewController.headerInformation?.className = seatClass.name
        seatMapSelectionViewController.headerInformation?.price = seatClass.price.yen
        navigationController?.pushViewController(seatMapSelectionViewController, animated: true)
    }
    
}
