//
//  SnackBarView.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import Foundation
import UIKit

final class SnackBarView: UIView {

    private enum Constants {
        static let cornerRadius: CGFloat = 14
        static let borderWidth = 1.0
    }

    // MARK: - UI Components

    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.openSansBold(ofSize: 14)
        messageLabel.textColor = UIColor.black.withAlphaComponent(0.9)
        return messageLabel
    }()

    private lazy var actionButton: UIButton = {
        let actionButton = UIButton(type: .system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.setTitleColor(UIColor.systemRed.withAlphaComponent(0.7), for: .normal)
        actionButton.titleLabel?.font = UIFont.openSansBold(ofSize: 14)
        actionButton.titleLabel?.numberOfLines = 0
        actionButton.titleLabel?.textAlignment = .center
        actionButton.titleLabel?.lineBreakMode = .byWordWrapping
        return actionButton
    }()

    // MARK: - Local variabel

    private var buttonWidthAnchor: NSLayoutConstraint?
    private var buttonRightAnchor: NSLayoutConstraint?
    private var messageRightAnchor: NSLayoutConstraint?
    private var messageRightButtonLeftAnchor: NSLayoutConstraint?

    required init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Private method

    private func setupView() {
        backgroundColor = UIColor.yellow.withAlphaComponent(0.7)
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.black.withAlphaComponent(0.9).cgColor
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(actionButton)
        addSubview(messageLabel)

        buttonWidthAnchor = actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        buttonRightAnchor = actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        messageRightButtonLeftAnchor = messageLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -SnackBarConst.innerViewPadding)
        messageRightAnchor = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SnackBarConst.innerViewPadding)
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: SnackBarConst.innerViewPadding),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SnackBarConst.innerViewPadding)
        ])

        buttonWidthAnchor?.isActive = false
        buttonRightAnchor?.isActive = true
        messageRightAnchor?.isActive = true
        messageRightButtonLeftAnchor?.isActive = false

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: SnackBarConst.innerViewPadding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SnackBarConst.innerViewPadding),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SnackBarConst.innerViewPadding)
        ])
    }

    // MARK: - Public Methods

    func setAction(with title: String, action: (() -> Void)? = nil) {

        buttonRightAnchor?.constant = -SnackBarConst.buttonPadding
        buttonWidthAnchor?.isActive = true
        messageRightAnchor?.isActive = false
        messageRightButtonLeftAnchor?.isActive = true
        actionButton.setTitle(title, for: .normal)
        actionButton.actionHandler(controlEvents: .touchUpInside) {
            action?()
        }
    }

    func setupStyle(with style: SnackBarStyle) {
        backgroundColor = style.backgroundColor
        layer.borderColor = style.borderColor.cgColor
        messageLabel.textColor = style.textColor
        messageLabel.textAlignment = style.textAlignment
        actionButton.setTitleColor(style.buttonTextColor, for: .normal)
    }

    func setMessageString(message: String) {
        messageLabel.text = message
    }
}


