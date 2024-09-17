//
//  SnackBar+Enum.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit

struct SnackBarStyle {
    let borderColor: UIColor
    let backgroundColor: UIColor
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    let buttonTextColor: UIColor

    init(borderColor: UIColor = UIColor.systemPurple.withAlphaComponent(0.9),
         backgroundColor: UIColor = UIColor.yellow.withAlphaComponent(0.7),
         textColor: UIColor = UIColor.black.withAlphaComponent(0.9),
         textAlignment: NSTextAlignment = .left,
         buttonTextColor: UIColor = UIColor.systemRed.withAlphaComponent(0.7)) {

        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.buttonTextColor = buttonTextColor
    }
}

enum SnackBarConst {
    static let padding: CGFloat = 0
    static let inViewPadding: CGFloat = 8
    static let snackBarViewHeight: CGFloat = 80
    static let viewWithButtonExtraPaddin: CGFloat = 70
    static let viewWithOutButtonExtraPaddin: CGFloat = 40
    static let innerViewPadding: CGFloat = 16
    static let buttonPadding: CGFloat = 27
    static let buttonWidth: CGFloat = 79
    static let actionButtonHeight: CGFloat = 23
}

extension SnackBar {

    enum Duration: Equatable {
        case long
        case short
        case infinite
        case custom(CGFloat)

        var value: CGFloat {
            switch self {
            case .long:
                return 10
            case .short:
                return 5
            case .infinite:
                return -1
            case .custom(let duration):
                return duration
            }
        }
    }

    enum AnimationTypeIn {
        case slideFromLeftToRightIn
        case slideFromRightToLeftIn
        case slideFrombottomIn
    }

    enum AnimationTypeOut {
        case slideFromRightToLeftOut
        case slideFromLeftToRightOut
        case slideFrombottomOut
    }

    enum SnackStyle {
        case error
        case success
        case redSuccess
        case custom(SnackBarStyle)

        var value: SnackBarStyle {
            switch self {

            case .error:
                return SnackBarStyle.init()
            case .success:
                return SnackBarStyle.init(backgroundColor: UIColor.green.withAlphaComponent(0.7),
                                          textColor: .white,
                                          textAlignment: .center)
            case .redSuccess:
                return SnackBarStyle.init(backgroundColor: UIColor.red.withAlphaComponent(0.7),
                                          textColor: .white,
                                          textAlignment: .center)
            case .custom(let style):
                return style
            }
        }
    }
}


