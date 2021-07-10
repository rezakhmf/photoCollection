//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Yurii Petelko on 2/21/20.
//  Copyright © 2020 Squire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let networkClient = PixabayNetworkClient()
    let listTableViewController = PhotoDetailsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        verifyEndpoint()
    }

    @IBAction func openDetailsScreen() {
        self.present(listTableViewController, animated: true, completion: nil)
    }

  // MARK: - Endpoint verification

    func verifyEndpoint() {
        // Do any additional setup after loading the view.
        networkClient.fetchImageList(for: "football") { result in
            print("Fetch images result \(result)")
        }
    }
}

