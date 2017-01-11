//
//  CatViewController.swift
//  LazyTransitionsExample
//
//  Created by Yopeso on 1/9/17.
//  Copyright © 2017 BeardWare. All rights reserved.
//

import UIKit

class CatViewController: UICollectionViewController {
    var didScrollCallback: (UIScrollView) -> () = { _ in }
    fileprivate var viewDidAppear: Bool = false
    fileprivate let reuseIdentifier = "PhotoCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
}

// MARK: - Public
extension CatViewController {
    static func instantiate(withTitle title: String) -> CatViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let catVC = storyboard.instantiateViewController(withIdentifier: "CatViewController") as! CatViewController
        catVC.navigationItem.title = title
        return catVC
    }
    
    func removeDismissButton() {
        navigationItem.rightBarButtonItem = nil
    }
}

// MARK: - Private
extension CatViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppear = true
    }
    
    @IBAction fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension CatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewDidAppear else { return }
        didScrollCallback(scrollView)
    }
}

// MARK: - UICollectionViewDataSource
extension CatViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 27
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCell
        cell.backgroundColor = UIColor.white
        cell.imageView.image = UIImage(named: "\(indexPath.row)")
        
        return cell
    }
}
