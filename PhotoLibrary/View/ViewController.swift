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
    var viewModel: PhotoCollectionViewModel?
    
    let listTableViewController = PhotoDetailsViewController()
    
    //MARK: - UI components
    private var collectionView: UICollectionView?
    
    // MARK: - Parameters
    private lazy var loadingOperations = [IndexPath : DataLoadOperation]()
    private lazy var dataStore = ImageDataStore()
    private lazy var loadingQueue = OperationQueue()
    
    
    private var photos: [PhotoInfo]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        
        configureViews()
        addViews()
        constraintViews()
        
    }
    
    func addViews() {
        self.view.addSubview(self.collectionView ?? UICollectionView())
    }
    
    func constraintViews() {
        self.collectionView?.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, padding: .init(top: 16, left: 8, bottom: 0, right:16), size: .init(width: self.view.frame.width, height: self.view.frame.height/2))
    }
    
    func configureViews() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //layout.minimumLineSpacing = 100
        //layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView?.register(cellWithClass: PhotoCollectionCell.self)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = .gray
    }
}


// MARK:- TableView Delegate
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
            if let dataLoader = dataStore.loadImage(at: indexPath.row) {
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
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
    
  
    
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let referenceHeight: CGFloat = 200 // Approximate height of your cell
            let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width / 2
            return CGSize(width: referenceWidth, height: referenceHeight)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 3.0
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
            if let dataLoader = dataStore.loadImage(at: indexPath.row) {
                loadingQueue.addOperation(dataLoader)
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




