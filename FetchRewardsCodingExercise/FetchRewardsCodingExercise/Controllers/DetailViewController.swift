// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// DetailViewController.swift

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var favoriteButton: UIBarButtonItem!

    @IBOutlet var name: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var location: UILabel!
    @IBOutlet var dateTime: UILabel!

    var event: Event?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadViews()
    }

    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        sender.title = sender.title == "Favorite!" ? "Interested?" : "Favorite!"
    }

    private func loadViews() {
        guard let event = event else { return }

        // image
        if let imageUrl = event.performers.first?.image {
            eventImageView.loadImage(with: imageUrl) {}
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
