//
//  DesignSystemComponentView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DesignSystemComponentView: DesignSystemView {
    
    let componentViews: [DesignSystemBlockView] = {
        return [
            .init(withView: {
                let button = Button(type: .contained)
                button.setTitle("Lorem Ipsum")
                return button
            }(),title: "Contained Button",
                constaintEquals: [.top, .bottom, .centerHorizontal]),
            
            .init(withView: {
                let button = Button(type: .outlined)
                button.setTitle("Lorem Ipsum")
                return button
            }(), title: "Outlined Button",
                 constaintEquals: [.top, .bottom, .centerHorizontal]),
            
            .init(withView: {
                let cardControl = CardControl(type: .regular)
                cardControl.translatesAutoresizingMaskIntoConstraints = false
                cardControl.heightAnchor.constraint(equalToConstant: 112).isActive = true
                return cardControl
            }(), title: "Card",
                 constaintEquals: .edges),
            
            .init(withView: {
                let cardControl = CardControl(type: .large)
                cardControl.translatesAutoresizingMaskIntoConstraints = false
                cardControl.heightAnchor.constraint(equalToConstant: 112).isActive = true
                return cardControl
            }(), title: "Large Card",
                 constaintEquals: .edges),
            
            .init(withView: {
                let segmentedControl = SegmentedControl()
                segmentedControl.items = [(title: "Item 1", subtitle: "Lorem Ipsum", true),
                                          (title: "Item 2", subtitle: "Lorem Ipsum", true),
                                          (title: "Item 3", subtitle: "Lorem Ipsum", true)]
                segmentedControl.translatesAutoresizingMaskIntoConstraints = false
                return segmentedControl
            }(), title: "Segmented Card Control",
                 constaintEquals: [.leading, .top, .bottom]),
            
            .init(withView: {
                let headlineLabelSetView =
                    HeadlineLabelSetView(title: "Lorem ipsum dolor",
                                         subtitle: "Lorem ipsum dolor",
                                         textAlignment: .left)
                return headlineLabelSetView
            }(), title: "Headline Label Set View",
                 constaintEquals: .edges),
            
            .init(withView: {
                let subheadlineLabelSet =
                    SubheadlineLabelSetView(title: "Lorem ipsum dolor",
                                            subtitle: "Lorem ipsum dolor",
                                            textAlignment: .left)
                return subheadlineLabelSet
            }(), title: "Subheadline Label Set View",
                 constaintEquals: .edges),
            
            .init(withView: {
                let labelSetView =
                    LabelSetView(type: .regular,
                                 title: "Lorem ipsum dolor",
                                 subtitle: "Lorem ipsum dolor",
                                 textAlignment: .left)
                return labelSetView
            }(), title: "Label Set View Regular",
                 constaintEquals: .edges),
            
            .init(withView: {
                let labelSetView =
                    LabelSetView(type: .small,
                                 title: "Lorem ipsum dolor",
                                 subtitle: "Lorem ipsum dolor",
                                 textAlignment: .left)
                return labelSetView
            }(), title: "Label Set View Small",
                 constaintEquals: .edges),
            
            .init(withView: {
                let stationPairView =
                    StationPairView(fromStation: "Bangkok", fromTime: "9:12",
                                    toStation: "Osaka", toTime: "12:43")
                return stationPairView
            }(), title: "Station Pair View",
                 constaintEquals: .edges),
            
            .init(withView: {
                let descriptionSetView =
                    DescriptionSetView(trainNumber: "Sakura 123",
                                       trainName: "E5 Series",
                                       carNumber: "Car 8",
                                       className: "GreenCar",
                                       seatNumber: "15C",
                                       price: "$14,200")
                return descriptionSetView
            }(), title: "Description Set View",
                 constaintEquals: .edges),
            
            .init(withView: {
                let headerRouteInformationView =
                    HeaderRouteInformationView(fromStation: "Bangkok", fromTime: "9:12",
                                               toStation: "Osaka", toTime: "12:43",
                                               trainNumber: "Sakura 123",
                                               trainName: "E5 Series",
                                               carNumber: "Car 8",
                                               className: "GreenCar",
                                               seatNumber: "15C",
                                               price: "$14,200")
                return headerRouteInformationView
            }(), title: "Description Set View",
                 constaintEquals: .edges),
            
            .init(withView: {
                let trainScheduleTableViewCell =
                    TrainScheduleTableViewCell(style: .default, reuseIdentifier: nil)
                trainScheduleTableViewCell.setupValue(time: "9:46 - 11:42",
                                                      amountOfTime: "3hr 12min",
                                                      trainNumber: "Hayabusa 231",
                                                      trainName: "E6 Series",
                                                      price: "$13,930",
                                                      trainImage: #imageLiteral(resourceName: "e7-series"))
                let trainScheduleTableViewCellContentView = trainScheduleTableViewCell.contentView
                return trainScheduleTableViewCellContentView
            }(), title: "Train Schedule Table View Cell",
                 constaintEquals: .edges),
            
            .init(withView: {
                let seatClassTableViewCell =
                    SeatClassTableViewCell(style: .default, reuseIdentifier: nil)
                seatClassTableViewCell
                    .setupValue(seatClassType: .green,
                                seatClassName: "GranClass",
                                price: "¥24,000",
                                description: "a first class travel with an experience of luxury ",
                                seatImage: nil)
                let seatClassTableViewCellContentView = seatClassTableViewCell.contentView
                return seatClassTableViewCellContentView
            }(), title: "Seat Class Table View Cell",
                 constaintEquals: .edges)
        ]
    }()
    
    init() {
        super.init(title: "Components",
                   designSystemBlockViews: componentViews)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
