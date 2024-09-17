//
//  UITextField Extension.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit

extension UITextField {

    convenience init(
        backgroundColor: UIColor = .label,
        cornerRadius: CGFloat = 5,
        placeholder: String,
        padding: CGFloat = 12,
        fontSize: CGFloat = 14,
        isSecure: Bool = false
    ) {
        self.init()
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
        self.textContentType = .oneTimeCode
        setLeftPaddingPoints(padding)
        setRightPaddingPoints(padding)
        self.font = UIFont.openSansRegular(ofSize: fontSize)
    }

    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        rightView = paddingView
        rightViewMode = .always
    }
}

