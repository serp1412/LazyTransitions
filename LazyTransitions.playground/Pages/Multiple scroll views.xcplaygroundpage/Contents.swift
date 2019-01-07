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

        /* 1. Become lazy for dismiss transition */
        becomeLazy(for: .dismiss)
        addTransition(forScrollView: collectionView)
    }

    /* 2. Add a transition for each scroll view that you want to trigger a transition.
     In our case each collection view in every RowCell */
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rowCell = cell as! RowCell
        addTransition(forScrollView: rowCell.collectionView)
    }

    deinit {
        print("happened")
    }
}

/* 3. Run the playground and flick the collection view to the very top or bottom to see how it bounces.

 Then try scrolling the cells to the very left or very right and see how they trigger a transition */












































/* Oh hey there, didn't expect you to scroll down here. You won't find anything special here, just some setup code ☺️ */

extension LazyViewController: UICollectionViewDelegateFlowLayout {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.register(RowCell.self, forCellWithReuseIdentifier: RowCell.identifier)
        view.addSubview(collectionView)
        collectionView.bindFrameToSuperviewBounds()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension LazyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RowCell.identifier,
                                                      for: indexPath) as! RowCell
        cell.backgroundColor = UIColor.white
        cell.setup()

        return cell
    }
}

let backVC = BackgroundViewController.instantiate(with: LazyViewController.self, action: { presented, presenting in
    presenting.present(presented, animated: true, completion: nil)
})
backVC.view.frame = .iphone6

PlaygroundPage.current.liveView = backVC.view

