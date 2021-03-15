// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// EventTableViewCell.swift

import UIKit

protocol ReusableView {
    static var reuseId: String { get }
}

class EventTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var dateTime: UILabel!

    var event: Event? {
        didSet {
            loadView()
        }
    }

    private func loadView() {
        guard let event = event else { return }

        if let imageUrl = event.performers.first?.image {
            eventImageView.loadImage(with: imageUrl) {}
        }

        name.text = event.title
        location.text = event.venue.displayLocation

        dateTime.text = event.datetimeLocal.displayDateString(dateTBD: event.dateTbd,
                                                              timeTBD: event.timeTbd)
    }
    
}

extension ReusableView where Self: UIView {
    static var reuseId: String {
        return String(describing: self)
    }
}
