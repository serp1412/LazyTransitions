import Foundation
import UIKit

public extension CGRect {
    public static var iphone6: CGRect { return CGRect(x: 0, y: 0, width: 750 / 2, height: 1334 / 2) }
    public static var iphone4: CGRect { return CGRect(x: 0, y: 0, width: 320, height: 480) }
    public static var ipad: CGRect { return CGRect(x: 0, y: 0, width: 1536 / 2, height: 2048 / 2) }
    public static var ipadLandscape: CGRect { return CGRect(x: 0, y: 0, width: 2048 / 2, height: 1536 / 2) }
}


public let images: [UIImage] = {
    return (0...26).map { UIImage(named: "\($0)")! }
}()

public let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
public let itemsPerRow: CGFloat = 3

public class PhotoCell: UICollectionViewCell {
    public static let identifier = "PhotoCell"
    public let imageView = UIImageView()

    public override func layoutSubviews() {
        if imageView.superview == nil {
            addSubview(imageView)
            imageView.bindFrameToSuperviewBounds()
        }
    }
}

public class RowCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    public static let identifier = "RowCell"
    public let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())

    public func setup() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        if collectionView.superview == nil {
            addSubview(collectionView)
            collectionView.bindFrameToSuperviewBounds()
        } 
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }
}

extension RowCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,
                                                      for: indexPath) as! PhotoCell
        cell.backgroundColor = UIColor.white
        cell.imageView.image = images.randomElement()!


        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}



public extension UIView {
    public func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true

    }
}

public extension UIView {
    public func bindToSuperviewCenter() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
}

public extension UIButton {
    public static var tapMe: UIButton  {
        let button = UIButton(type: .system)

        button.backgroundColor = UIColor.red
        button.setTitle("Tap me!", for: .normal)
        button.setTitleColor(.white, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        button.layer.cornerRadius = 200 / 2

        return button
    }
}

public class BackgroundViewController <T: UIViewController>: UIViewController, UINavigationControllerDelegate {
    public var screenToPresent: T.Type!
    var action: ((UIViewController, UIViewController) -> ())!

    public static func instantiate(with screen: T.Type, action: @escaping (_ presented: UIViewController, _ presenting: UIViewController) -> ()) -> BackgroundViewController {
        let backVC = BackgroundViewController()
        backVC.action = action
        backVC.screenToPresent = screen

        return backVC
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let button = UIButton.tapMe
        view.addSubview(button)
        button.bindToSuperviewCenter()

        button.addTarget(self, action: #selector(triggerAction), for: .touchUpInside)
    }

    @objc func triggerAction() {
        action(screenToPresent.init(), self)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("nav was called")
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("nav was called")
    }
}

