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
    var photoCollectionviewModel: PhotoCollectionViewModel?
    var photoDetailsviewModel: PhotoDetailsViewModel?
    
    private let spacing:CGFloat = 8.0
    
    
    let listTableViewController = PhotoDetailsViewController()
    
    //MARK: - UI components
    private var collectionView: UICollectionView?
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Parameters
    private lazy var loadingOperations = [IndexPath : DataLoadOperation]()
    
    private var photos: [PhotoInfo]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.collectionView?.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .bottom)
                self.collectionView(self.collectionView ?? UICollectionView(), didSelectItemAt: IndexPath(item: 0, section: 0))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK:- setup views
extension ViewController {
    
    func setup() {
        
        self.photoCollectionviewModel = PhotoCollectionViewModel()
        self.photoDetailsviewModel = PhotoDetailsViewModel()
        refreshData()
        
        configureViews()
        addViews()
        constraintViews()
        
    }
    
    func addViews() {
        self.view.addSubview(self.collectionView ?? UICollectionView())
    }
    
    func constraintViews() {
        self.collectionView?.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor, centerX: nil, padding: .init(top: 16, left: 8, bottom: 0, right:16), size: .init(width: self.view.frame.width, height: self.view.frame.height / 2))
    }
    
    func configureViews() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        self.view.backgroundColor = .gray
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView?.refreshControl = self.refreshControl
        self.collectionView?.register(cellWithClass: PhotoCollectionCell.self)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = .gray
        
        // Configure Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshPhotoLibrary(_:)), for: .valueChanged)
        self.refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        self.refreshControl.attributedTitle = NSAttributedString(string: "refresh data ...", attributes: nil)
    }
    
    @objc private func refreshPhotoLibrary(_ sender: Any) {
        //MARK: - fetch info visa refresh
        refreshData()
    }
    
    private func refreshData() {
        //MARK: - fetch info visa refresh
        self.photoCollectionviewModel?.getPhotosCollection { photos in
            self.photos = photos
            self.photoCollectionviewModel?.dataStore.photos = photos
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
    }
}

// MARK:- UICollectionViewDelegate Delegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
            if let dataLoader = self.photoCollectionviewModel?.dataStore.loadImage(at: indexPath.row) {
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                self.photoCollectionviewModel?.loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // If there's a data loader for this index path we don't need it any more. Cancel and dispose
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let photo = photos?[indexPath.row] else {
            return
        }
        
        photoDetailsviewModel?.getPhotoInfo(photoInfo: photo) { result in
            if(result) {
                self.listTableViewController.photoDetails?.removeAll()
                self.listTableViewController.photoDetails = self.photoDetailsviewModel?.deteils
                
                self.view.addSubview(self.listTableViewController.tableView)
                
                self.listTableViewController.tableView.anchor(top: self.collectionView?.bottomAnchor, leading: self.collectionView?.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.collectionView?.trailingAnchor, centerX: nil, padding: .init(top: 16, left: 0, bottom: 0, right:0), size: .init(width: self.view.frame.width, height: 200))
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 2
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK:- TableView Datasource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(withClass: PhotoCollectionCell.self, for: indexPath)
        
        cell.configure(photoInfo: .none, image: .none)
        
        return cell
    }
}

// MARK:- TableView Prefetching DataSource
extension ViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] { return }
            if let dataLoader = self.photoCollectionviewModel?.dataStore.loadImage(at: indexPath.row) {
                self.photoCollectionviewModel?.loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}



