/*:
 # How to add a bouncy effect to scroll view transitions
 */

import LazyTransitions
import UIKit
import PlaygroundSupport

class LazyViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 1. Become lazy for your transition type */
        becomeLazy(for: .dismiss)

        /* 2. Add transition for your scroll view. Bouncy effect will be applied automatically */
        addTransition(forScrollView: collectionView)
    }

    deinit {
        print("happened")
    }
}

/* 3. Run the playground and flick the collection view to the very top or bottom to see how it bounces.

 **NOTE** to opt out of the bouncy effect just call `addTransition(forScrollView: collectionView, bouncyEdges: false)`
 */




























/* Oh hey there, didn't expect you to scroll down here. You won't find anything special here, just some setup code ☺️ */

let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
let itemsPerRow: CGFloat = 3

extension LazyViewController: UICollectionViewDelegateFlowLayout {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        view.addSubview(collectionView)
        collectionView.bindFrameToSuperviewBounds()
        collectionView.delegate = self
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,
                                                      for: indexPath) as! PhotoCell
        cell.backgroundColor = UIColor.white
        cell.imageView.image = UIImage(named: "\(indexPath.row)")


        return cell
    }
}

let backVC = BackgroundViewController.instantiate(with: LazyViewController.self, action: { presented, presenting in
    presenting.present(presented, animated: true, completion: nil)
})
backVC.view.frame = .iphone6

PlaygroundPage.current.liveView = backVC.view


