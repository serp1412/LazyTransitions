/*:
 # How to add a bouncy effect to scroll view transitions
 */

import LazyTransitions
import UIKit
import PlaygroundSupport

/* 1. Conform your screen to LazyScreen */
class LazyViewController: UIViewController, LazyScreen {

    /* 2. Override the `scrollViews` property from `LazyScreen` conformance and pass in it the scroll views of your screen that you want to trigger transitions */
    var scrollViews: [UIScrollView] { return [collectionView] }

    /* 3. Create the `transitioner` property  */
    var transitioner: LazyTransitioner?

    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 4. Initialize your transitioner */
        transitioner = .init(lazyScreen: self,
                             transition: .dismiss)

        /* 5. Become the delegate of your scroll view (or any class that inherits from scroll view) */
        collectionView.delegate = self
    }

    /* 6. Implement the `scrollViewDidScroll` delegate method */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        transitioner?.didScroll(scrollView)
    }
}

/* 7. Run the playground and flick the collection view to the very top or bottom to see how it bounces. */




























/* Oh hey there, didn't expect you to scroll down here. You won't find anything special here, just some setup code ☺️ */

let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
let itemsPerRow: CGFloat = 3

extension LazyViewController: UICollectionViewDelegateFlowLayout {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        view.addSubview(collectionView)
        collectionView.bindFrameToSuperviewBounds()
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }

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
}

// MARK: - UICollectionViewDataSource
extension LazyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 27
    }

    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",
                                                      for: indexPath) as! PhotoCell
        cell.backgroundColor = UIColor.white
        cell.imageView.image = UIImage(named: "\(indexPath.row)")


        return cell
    }
}

class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()

    override func layoutSubviews() {
        if imageView.superview == nil {
            addSubview(imageView)
            imageView.bindFrameToSuperviewBounds()
        }
    }
}

let backVC = UIViewController()
backVC.view.backgroundColor = .white

backVC.view.frame = CGRect.init(x: 0, y: 0, width: 750 / 2, height: 1334 / 2)

PlaygroundPage.current.liveView = backVC.view

backVC.present(LazyViewController(), animated: true, completion: nil)
