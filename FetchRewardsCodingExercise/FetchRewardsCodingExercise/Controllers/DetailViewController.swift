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
        guard let event = event else { return }
        let coreData = CoreDataStack.shared

        if sender.title == "Interested?" {
            coreData.saveFavorite(id: event.id, expiration: event.visibleUntilUtc)
        } else {
            coreData.deleteFavorite(id: Int64(event.id))
        }

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

        dateTime.text = event.datetimeLocal.displayDateString(dateTBD: event.dateTbd,
                                                              timeTBD: event.timeTbd)

        favoriteButton.title = CoreDataStack.shared.isFavorite(id: event.id) ? "Favorite!" : "Interested?"
    }

}
