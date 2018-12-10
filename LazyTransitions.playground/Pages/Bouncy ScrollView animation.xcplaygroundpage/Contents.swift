import LazyTransitions
import UIKit
import PlaygroundSupport

class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()

    override func layoutSubviews() {
        if imageView.superview == nil {
            addSubview(imageView)
            imageView.bindFrameToSuperviewBounds()
        }
    }
}

class LazyViewController: UIViewController {
    let transitioner = LazyTransitioner()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cellId = "PhotoCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()

       collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        collectionView.bindFrameToSuperviewBounds()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        transitioningDelegate = transitioner
        transitioner.addTransition(forView: view)
        transitioner.addTransition(forScrollView: collectionView)
        transitioner.triggerTransitionAction = { [weak self] transitioner in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

extension LazyViewController: UICollectionViewDelegateFlowLayout {
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        transitioner.didScroll(scrollView)
    }
}

// MARK: - UICollectionViewDataSource
extension LazyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 27
    }

    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! PhotoCell
        cell.backgroundColor = UIColor.white
        cell.imageView.image = UIImage(named: "\(indexPath.row)")


        return cell
    }
}

let backVC = UIViewController()
backVC.view.backgroundColor = .white

backVC.view.frame = CGRect.init(x: 0, y: 0, width: 750 / 2, height: 1334 / 2)

PlaygroundPage.current.liveView = backVC.view

backVC.present(LazyViewController(), animated: true, completion: nil)
