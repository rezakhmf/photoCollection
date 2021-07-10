//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Yurii Petelko on 2/21/20.
//  Copyright © 2020 Squire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - Dependencies
//    let networkClient = PixabayNetworkClient()
    var viewModel: PhotoCollectionViewModel?
    
    let listTableViewController = PhotoDetailsViewController()
    
    //MARK: - UI components
    let tableView = UITableView()
    
    // MARK: - Parameters
    private lazy var loadingOperations = [IndexPath : DataLoadOperation]()
    private lazy var dataStore = ImageDataStore()
    private lazy var loadingQueue = OperationQueue()
    
    
    private var photos: [PhotoInfo]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //verifyEndpoint()
    }
    
    @IBAction func openDetailsScreen() {
        self.present(listTableViewController, animated: true, completion: nil)
    }
}

// MARK:- setup views
extension ViewController {
    func setup() {
        self.viewModel = PhotoCollectionViewModel()
        self.viewModel?.getPhotosCollection { photos in
            self.photos = photos
            self.dataStore.photos = photos
        }
        addViews()
        constraintViews()
        configureViews()
    }
    
    func addViews() {
        [tableView].forEach { self.view.addSubview($0) }
    }
    
    func constraintViews() {
        tableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, padding: .init(top: 16, left: 8, bottom: 0, right: 0), size: .init(width: self.view.frame.width, height: self.view.frame.height/2))
    }
    
    func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhotoCollectionCell.self)
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}


// MARK:- TableView Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? PhotoCollectionCell else { return }
        
        
        // How should the operation update the cell once the data has been loaded?
        let updateCellClosure: (UIImage?) -> () = { [unowned self] (image) in
            cell.configure(photoInfo: photos?[indexPath.row], image: image)
        }
        
        // Try to find an existing data loader
        if let dataLoader = loadingOperations[indexPath] {
            // Has the data already been loaded?
            if let image = dataLoader.image {
                cell.configure(photoInfo: photos?[indexPath.row], image: image)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                // No data loaded yet, so add the completion closure to update the cell once the data arrives
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            // Need to create a data loaded for this index path
            if let dataLoader = dataStore.loadImage(at: indexPath.row) {
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If there's a data loader for this index path we don't need it any more. Cancel and dispose
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}

// MARK:- TableView Datasource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoCollectionCell = tableView.dequeueCell(forIndexPath: indexPath)
        cell.configure(photoInfo: .none, image: .none)
        return cell
    }
}

// MARK:- TableView Prefetching DataSource
extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] { return }
            if let dataLoader = dataStore.loadImage(at: indexPath.row) {
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}




