import UIKit

extension UIColor {

    static var customDarkGray: UIColor = {
        return UIColor (red: 184/255, green: 184/255, blue: 184/255, alpha: 1.0)
    }()

    static var customLightGray: UIColor = {
        return UIColor (red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0)
    }()

    static var customBlack: UIColor = {
        return UIColor (red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    }()

    static var authDark: UIColor = {
        return UIColor (red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    }()

    static var background: UIColor = {
        return UIColor (dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor.white
            } else {
                return UIColor.systemGray4
            }
        })

    }()

    static var elements: UIColor = {
        return UIColor (dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor.customBlack
            } else {
                return UIColor.customLightGray
            }
        })
    }()

    static var label: UIColor = {

        return UIColor (dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor.customLightGray
            } else {
                return UIColor.systemGray5
            }
        })
    }()

    static let labelColors: UIColor = {

        return UIColor (dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor.customBlack
            } else {
                return UIColor.white
            }
        })

    }()

}
