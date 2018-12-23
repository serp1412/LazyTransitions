import Foundation
import UIKit

public extension CGRect {
    public static var iphone6: CGRect { return CGRect(x: 0, y: 0, width: 750 / 2, height: 1334 / 2) }
    public static var iphone4: CGRect { return CGRect(x: 0, y: 0, width: 320, height: 480) }
    public static var ipad: CGRect { return CGRect(x: 0, y: 0, width: 1536 / 2, height: 2048 / 2) }
    public static var ipadLandscape: CGRect { return CGRect(x: 0, y: 0, width: 2048 / 2, height: 1536 / 2) }
}
