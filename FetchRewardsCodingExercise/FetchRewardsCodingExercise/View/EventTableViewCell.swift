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

        // image
        if #available(iOS 13.0, *) {
            if eventImageView.image is UIImage {
                if let imageUrl = event.performers.first?.image {
                    eventImageView.loadImage(with: imageUrl) {}
                }
            }
        } else {
            if eventImageView.image == nil {
                if let imageUrl = event.performers.first?.image {
                    eventImageView.loadImage(with: imageUrl) {}
                }
            }
        }

        name.text = event.title
        location.text = event.venue.displayLocation

        // date
        let formatter = DateFormatter()
        if let dateToFormat = formatter.date(from: event.datetimeLocal) {
            switch (event.dateTbd, event.timeTbd) {
            case (false, false):
                formatter.dateFormat = "EEEE, MMMM d, yyyy, h:mm a"
            case (false, true):
                formatter.dateFormat = "EEEE, MMMM d, yyyy"
            default:
                dateTime.text = "TBD"
            }

            dateTime.text = formatter.string(from: dateToFormat)
        } else {
            dateTime.text = "Check website for date & time"
        }

    }

}

extension ReusableView where Self: UIView {
    static var reuseId: String {
        return String(describing: self)
    }
}
