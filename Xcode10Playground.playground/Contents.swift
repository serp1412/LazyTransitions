/*:
 # How to add a bouncy effect to scroll view transitions
 */

import LazyTransitions
import UIKit
import PlaygroundSupport

/* 1. Conform your screen to LazyScreen */
class LazyViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 4. Initialize your transitioner */
        becomeLazy(for: .dismiss)
        addTransition(forScrollView: collectionView)

        /* 5. Become the delegate of your scroll view (or any class that inherits from scroll view) */
        collectionView.delegate = self
    }

    /* 6. Implement the `scrollViewDidScroll` delegate method */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        transitioner?.didScroll(scrollView)
    }
}




/* 7. Run the playground and flick the collection view to the very top or bottom to see how it bounces. */



class MiddleManClass: NSObject, UIScrollViewDelegate {
    let interceptor: NSProtocolInterceptor

    override init() {
        self.interceptor = NSProtocolInterceptor.forProtocol(aProtocol: UIScrollViewDelegate.self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("MIDDLEMAN GOT IT!!")
    }
}



/**
 `NSProtocolInterceptor` is a proxy which intercepts messages to the middle man
 which originally intended to send to the receiver.

 - Discussion: `NSProtocolInterceptor` is a class cluster which dynamically
 subclasses itself to conform to the intercepted protocols at the runtime.
 */
public final class NSProtocolInterceptor: NSObject {
    /// Returns the intercepted protocols
    public var interceptedProtocols: [Protocol] { return _interceptedProtocols }
    private var _interceptedProtocols: [Protocol] = []

    /// The receiver receives messages
    public weak var receiver: NSObjectProtocol?

    /// The middle man intercepts messages
    public weak var middleMan: NSObjectProtocol?

    private func doesSelectorBelongToAnyInterceptedProtocol(
        aSelector: Selector) -> Bool
    {
        for aProtocol in _interceptedProtocols
            where sel_belongsToProtocol(aSelector, aProtocol)
        {
            return true
        }
        return false
    }

    /// Returns the object to which unrecognized messages should first be
    /// directed.
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if middleMan?.responds(to: aSelector) == true &&
            doesSelectorBelongToAnyInterceptedProtocol(aSelector: aSelector)
        {
            return middleMan
        }

        if receiver?.responds(to: aSelector) == true {
            return receiver
        }

        return super.forwardingTarget(for: aSelector)
    }

    /// Returns a Boolean value that indicates whether the receiver implements
    /// or inherits a method that can respond to a specified message.
    public override func responds(to aSelector: Selector!) -> Bool {
        if middleMan?.responds(to: aSelector) == true &&
            doesSelectorBelongToAnyInterceptedProtocol(aSelector: aSelector)
        {
            return true
        }

        if receiver?.responds(to: aSelector) == true {
            return true
        }

        return super.responds(to: aSelector)
    }

    /**
     Create a protocol interceptor which intercepts a single Objecitve-C
     protocol.

     - Parameter     protocols:  An Objective-C protocol, such as
     UITableViewDelegate.self.
     */
    public class func forProtocol(aProtocol: Protocol)
        -> NSProtocolInterceptor
    {
        return forProtocols(protocols: [aProtocol])
    }

    /**
     Create a protocol interceptor which intercepts a variable-length sort of
     Objecitve-C protocols.

     - Parameter     protocols:  A variable length sort of Objective-C protocol,
     such as UITableViewDelegate.self.
     */
    public class func forProtocols(protocols: Protocol ...)
        -> NSProtocolInterceptor
    {
        return forProtocols(protocols: protocols)
    }

    /**
     Create a protocol interceptor which intercepts an array of Objecitve-C
     protocols.

     - Parameter     protocols:  An array of Objective-C protocols, such as
     [UITableViewDelegate.self].
     */
    public class func forProtocols(protocols: [Protocol])
        -> NSProtocolInterceptor
    {
        let protocolNames = protocols.map { NSStringFromProtocol($0) }
        let sortedProtocolNames = protocolNames.sorted()
        let concatenatedName = sortedProtocolNames.joined(separator: ",")

        let theConcreteClass = concreteClassWithProtocols(protocols: protocols,
                                                          concatenatedName: concatenatedName,
                                                          salt: nil)

        let protocolInterceptor = theConcreteClass.init()
            as! NSProtocolInterceptor
        protocolInterceptor._interceptedProtocols = protocols

        return protocolInterceptor
    }

    /**
     Return a subclass of `NSProtocolInterceptor` which conforms to specified
     protocols.

     - Parameter     protocols:          An array of Objective-C protocols. The
     subclass returned from this function will conform to these protocols.

     - Parameter     concatenatedName:   A string which came from concatenating
     names of `protocols`.

     - Parameter     salt:               A UInt number appended to the class name
     which used for distinguishing the class name itself from the duplicated.

     - Discussion: The return value type of this function can only be
     `NSObject.Type`, because if you return with `NSProtocolInterceptor.Type`,
     you can only init the returned class to be a `NSProtocolInterceptor` but not
     its subclass.
     */
    private class func concreteClassWithProtocols(protocols: [Protocol],
                                                  concatenatedName: String,
                                                  salt: UInt?)
        -> NSObject.Type
    {
        let className: String = {
            let basicClassName = "_" +
                NSStringFromClass(NSProtocolInterceptor.self) +
                "_" + concatenatedName

            if let salt = salt { return basicClassName + "_\(salt)" }
            else { return basicClassName }
        }()

        let nextSalt = salt.map {$0 + 1}

        if let theClass = NSClassFromString(className) {
            switch theClass {
            case let anInterceptorClass as NSProtocolInterceptor.Type:
                let isClassConformsToAllProtocols: Bool = {
                    // Check if the found class conforms to the protocols
                    for eachProtocol in protocols
                        where !class_conformsToProtocol(anInterceptorClass,
                                                        eachProtocol)
                    {
                        return false
                    }
                    return true
                }()

                if isClassConformsToAllProtocols {
                    return anInterceptorClass
                } else {
                    return concreteClassWithProtocols(protocols: protocols,
                                                      concatenatedName: concatenatedName,
                                                      salt: nextSalt)
                }
            default:
                return concreteClassWithProtocols(protocols: protocols,
                                                  concatenatedName: concatenatedName,
                                                  salt: nextSalt)
            }
        } else {
            let subclass = objc_allocateClassPair(NSProtocolInterceptor.self,
                                                  className,
                                                  0)
                as! NSObject.Type

            for eachProtocol in protocols {
                class_addProtocol(subclass, eachProtocol)
            }

            objc_registerClassPair(subclass)

            return subclass
        }
    }
}

/**
 Returns true when the given selector belongs to the given protocol.
 */
public func sel_belongsToProtocol(_ aSelector: Selector,
                                  _ aProtocol: Protocol) -> Bool
{
    for optionBits: UInt in 0..<(1 << 2) {
        let isRequired = optionBits & 1 != 0
        let isInstance = !(optionBits & (1 << 1) != 0)

        var methodDescription = protocol_getMethodDescription(aProtocol,
                                                              aSelector, isRequired, isInstance)

        if !objc_method_description_isEmpty(methodDescription: &methodDescription)
        {
            return true
        }
    }
    return false
}

public func objc_method_description_isEmpty(methodDescription: inout objc_method_description)
    -> Bool
{
    let ptr: UnsafePointer<Int8> = withUnsafePointer(to: methodDescription) { pointer in
        let copy = pointer as UnsafePointer<objc_method_description>
        let opaque: OpaquePointer = OpaquePointer.init(copy)
        return UnsafePointer<Int8>.init(opaque)
    }
    for offset in 0..<MemoryLayout.size(ofValue: methodDescription) {
        if ptr[offset] != 0 {
            return false
        }
    }
    return true
}























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
        print("number of items")
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

let backVC = BackgroundViewController.instantiate(with: LazyViewController(), action: { presented, presenting in
    presenting.present(presented, animated: true, completion: nil)
})
backVC.view.frame = .iphone6

PlaygroundPage.current.liveView = backVC.view


