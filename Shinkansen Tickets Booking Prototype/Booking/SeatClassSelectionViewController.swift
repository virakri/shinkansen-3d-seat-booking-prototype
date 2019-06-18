//
//  SeatClassSelectionViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class SeatClassSelectionViewController: BookingViewController {
    
    var trainImage: UIImage?
    
    var trainImageView: UIImageView!
    
    var selectedIndexPath: IndexPath?
    
    var seatClasses: [SeatClass] = []
    
    var seatMap: SeatMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupStaticContent()
        obtainData()
    }
    
    override func setupView() {
        super.setupView()
        mainViewType = .tableView
        
        headerRouteInformationView
            .descriptionSetView.addArrangedSubview(UIView())
        
        trainImageView = UIImageView()
        
        headerRouteInformationView
            .descriptionSetView
            .addSubview(trainImageView)
        
        trainImageView
            .translatesAutoresizingMaskIntoConstraints = false
        
        trainImageView
            .leadingAnchor
            .constraint(
                greaterThanOrEqualTo:
                headerRouteInformationView
                    .descriptionSetView
                    .trainNumberSetView
                    .trailingAnchor,
                constant: 48)
            .isActive = true
        
        let trainImageViewTrailingConstraint =
        trainImageView
            .trailingAnchor
            .constraint(
                equalTo:
                view.trailingAnchor)
        
        trainImageViewTrailingConstraint.priority = .defaultLow
        trainImageViewTrailingConstraint.isActive = true
        
        trainImageView
            .topAnchor
            .constraint(
                equalTo: headerRouteInformationView
                    .stationPairView
                    .bottomAnchor,
                constant: 12)
            .isActive = true
        
        headerRouteInformationView
            .descriptionSetView
            .bottomAnchor
            .constraint(
                equalTo: trainImageView.bottomAnchor)
            .isActive = true
        
        trainImageView.widthAnchor.constraint(equalTo: trainImageView.heightAnchor, multiplier: 6).isActive = true
        trainImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .vertical)
        trainImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .horizontal)
        
    }
    
    func obtainData() {
        SeatMap.fetchData { [weak self] result in
            if case .success(let seatMap) = result {
                self?.seatMap = seatMap
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let decoder = JSONDecoder()
            if let data = NSDataAsset(name: "ModelData")?.data,
                let modelData = try? decoder.decode([ModelData].self, from: data) {
                    NodeFactory.shared =
                        NodeFactory(modelData: modelData)
            }else{
                NodeFactory.shared =
                    NodeFactory(url:
                        URL(string: "https://v-eyes-tracking-prototype.firebaseio.com/data.json")!)
            }
        }
        
        
    }

    func setupStaticContent() {
        trainImageView.image = trainImage
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
        
        let seatMapSelectionVC = SeatMapSelectionViewController()
        seatMapSelectionVC.seatClass = seatClass
        seatMapSelectionVC.seatClassEntity = selectedEntity
        seatMapSelectionVC.seatMap = seatMap
        seatMapSelectionVC.headerInformation = headerInformation
        seatMapSelectionVC.headerInformation?.carNumber = selectedEntity?.carNumber
        seatMapSelectionVC.headerInformation?.className = seatClass.name
        seatMapSelectionVC.headerInformation?.price = seatClass.price.yen
        navigationController?.pushViewController(seatMapSelectionVC, animated: true)
    }
    
}
