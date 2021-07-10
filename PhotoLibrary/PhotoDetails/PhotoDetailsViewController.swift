//
//  PhotoDetailsViewController.swift
//  PhotoLibrary
//
//  Created by Yurii Petelko on 3/12/20.
//  Copyright © 2020 Squire. All rights reserved.
//

import UIKit

final class PhotoDetailsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "PhotoDetailTableViewCell", bundle: nil),
                           forCellReuseIdentifier: PhotoDetailTableViewCell.reuseIdentifier)
    }
}

// MARK: - DataSource

extension PhotoDetailsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView .dequeueReusableCell(
            withIdentifier: PhotoDetailTableViewCell.reuseIdentifier, for: indexPath) as? PhotoDetailTableViewCell else {
                    fatalError("Unregistered table view cell")
        }

        cell.titleLabel.text = "Mock text 1"
        cell.subtitleLabel.text = "Mock text 2"

        return cell
    }
}
