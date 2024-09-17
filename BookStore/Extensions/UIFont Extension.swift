import UIKit

extension UIFont {

    static func openSansRegular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-Regular", size: ofSize)
    }

    static func openSansBold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-Bold", size: ofSize)
    }

    static func openSansItalic(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-Italic", size: ofSize)
    }

    static func openSansSemiBoldItalic(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-SemiBoldItalic", size: ofSize)
    }
}
