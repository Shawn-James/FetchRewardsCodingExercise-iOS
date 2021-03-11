// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// SearchTableViewController.swift

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!

    let seatGeak = SeatGeek()
    var events = Events() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        cell.event = events[indexPath.row]

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(throttledSearch),
                                               object: nil)

        perform(#selector(throttledSearch), with: nil, afterDelay: 0.2)
        // throttling improves performance and reduces calls
    }

    @objc func throttledSearch() {
        guard let searchText = searchBar.text, !searchText.isEmpty else { events.removeAll(keepingCapacity: true); return }

        seatGeak.getSearchResults(for: searchText) { [weak self] result in
            switch result {
            case let .success(searchResults):
                if let results = searchResults {
                    self?.events = results
                }
            case let .failure(searchError):
                print(searchError)
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let detailViewController = segue.destination as? DetailViewController,
            let selectedRow = tableView.indexPathForSelectedRow?.row
        else {
            return
        }

        detailViewController.event = events[selectedRow]
    }

}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard
            let cell = dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseId)")
        }

        return cell
    }
}
