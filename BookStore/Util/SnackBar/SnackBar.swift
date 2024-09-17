//
//  SnackBar.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit

protocol SnackBarAction {
    func setAction(with title: String, action: (() -> Void)?) -> SnackBarPresentable
}

protocol SnackBarPresentable: SnackBar {
    func show()
    func dismiss()
    func setStyle(with styleType: SnackStyle) -> SnackBarPresentable
}

final class SnackBar: UIView, SnackBarAction, SnackBarPresentable {

    private enum Constants {
        static let animationDuration = 0.5
        static let animationDelay: TimeInterval = 0
    }

    // MARK: - UI Components

    private lazy var snackBarView: SnackBarView = {
        let view = SnackBarView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Local variabel

    private let message: String
    private let duration: Duration
    private let cameInAnimation: AnimationTypeIn
    private let cameOutAnimation: AnimationTypeOut
    private var dismissTimer: Timer?
    private var isActionSet: Bool = false
    private var snackBarViewHeightAnchor: NSLayoutConstraint?

    required internal init(message: String,
                           duration: Duration,
                           cameInAnimation: AnimationTypeIn = .slideFromLeftToRightIn,
                           cameOutAnimation: AnimationTypeOut = .slideFromLeftToRightOut) {
        self.message = message
        self.duration = duration
        self.cameInAnimation = cameInAnimation
        self.cameOutAnimation = cameOutAnimation
        super.init(frame: .zero)
    }

    required internal init?(coder: NSCoder) {
        return nil
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if subview is SnackBarView && subview.frame.contains(point) {
                return true
            }
        }
        return false
    }

    // MARK: - Public Methods

    static func make(message: String,
                            duration: Duration,
                            cameInAnimation: AnimationTypeIn = .slideFromLeftToRightIn,
                            cameOutAnimation: AnimationTypeOut = .slideFromLeftToRightOut) -> Self {

        removeOldViews()
        return Self.init(message: message,
                         duration: duration,
                         cameInAnimation: cameInAnimation,
                         cameOutAnimation: cameOutAnimation)
    }

    func setAction(with title: String,
                   action: (() -> Void)? = nil) -> SnackBarPresentable {
        isActionSet = true
        snackBarView.setAction(with: title) {[weak self] in
            self?.dismiss()
            action?()
        }
        return self
    }

    func setStyle(with styleType: SnackStyle) -> SnackBarPresentable {
        snackBarView.setupStyle(with: styleType.value)
        return self
    }

    func show() {
        setupView()
        setupSwipe()
        prepareAnimationIn(animationType: cameInAnimation) { [weak self] _ in
            guard let self = self else { return }

            if self.duration != .infinite {
                self.dismissTimer = Timer.init(
                    timeInterval: TimeInterval(self.duration.value),
                    target: self, selector: #selector(self.dismiss),
                    userInfo: nil, repeats: false)

                guard let dismissTimer = self.dismissTimer else { return }
                RunLoop.main.add(dismissTimer, forMode: .common)
            }
        }
    }

    @objc func dismiss() {
        invalidDismissTimer()

        prepareAnimationOut(animationType: cameOutAnimation) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }

    // MARK: - Private method

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        guard let keyWindow = UIApplication.shared.currentUIWindow() else { return }
        keyWindow.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.topAnchor, constant: SnackBarConst.padding),
            leadingAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.leadingAnchor, constant: SnackBarConst.padding),
            trailingAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.trailingAnchor, constant: -SnackBarConst.padding),
            bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -SnackBarConst.padding)
        ])

        addSubview(snackBarView)
        let buttonWidth = (UIScreen.main.bounds.size.width - (2 * SnackBarConst.inViewPadding)) / 3

        let widthMinus = (2 * SnackBarConst.innerViewPadding) + (2 * SnackBarConst.inViewPadding) + (!isActionSet ? 0 : SnackBarConst.buttonPadding + buttonWidth)

        let estimateSnackViewHeight = message.heightForLabel(
            font: UIFont.openSansRegular(ofSize: 14)!,
            width: UIScreen.main.bounds.size.width - widthMinus) + (2 * SnackBarConst.innerViewPadding)

        snackBarViewHeightAnchor = snackBarView.heightAnchor.constraint(equalToConstant: estimateSnackViewHeight)

        NSLayoutConstraint.activate([
            snackBarView.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -SnackBarConst.inViewPadding),
            snackBarView.trailingAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.trailingAnchor, constant: -SnackBarConst.inViewPadding),
            snackBarView.leadingAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.leadingAnchor, constant: SnackBarConst.inViewPadding)
        ])
        snackBarViewHeightAnchor?.isActive = true
        snackBarView.setMessageString(message: message)
        superview?.layoutIfNeeded()
    }
    private func setupSwipe() {
        addSwipeGestureAllDirection(action: #selector(swipeAction(_:)))
    }

    @objc private func swipeAction(_ sender: UISwipeGestureRecognizer) {
        dismiss()
    }

    private static func removeOldViews() {
        guard let keyWindow = UIApplication.shared.currentUIWindow() else { return }

        keyWindow.rootViewController?
            .view
            .subviews
            .filter({ $0 is Self })
            .forEach({ $0.removeFromSuperview() })
    }

    private func prepareAnimationIn(animationType: AnimationTypeIn, completion: ((Bool) -> Void)? = nil) {
        var newTransform = CGAffineTransform(translationX: 0, y: 0)

        switch animationType {
        case .slideFromLeftToRightIn:
            snackBarView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.size.width, y: 0)
            newTransform = CGAffineTransform(translationX: 0, y: 0)
        case .slideFromRightToLeftIn:
            snackBarView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.size.width, y: 0)
            newTransform = CGAffineTransform(translationX: 0, y: 0)
        case .slideFrombottomIn:
            snackBarView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height)
            newTransform = CGAffineTransform(translationX: 0, y: 0)
        }

        animation(newTransform: newTransform, completion: completion)
    }

    private func prepareAnimationOut(animationType: AnimationTypeOut, completion: ((Bool) -> Void)? = nil) {
        var newTransform = CGAffineTransform(translationX: 0, y: 0)

        switch animationType {
        case .slideFromRightToLeftOut:
            snackBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            newTransform = CGAffineTransform(translationX: -UIScreen.main.bounds.size.width, y: 0)
        case .slideFromLeftToRightOut:
            snackBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            newTransform = CGAffineTransform(translationX: UIScreen.main.bounds.size.width, y: 0)
        case .slideFrombottomOut:
            snackBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            newTransform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height)
        }

        animation(newTransform: newTransform, completion: completion)
    }

    private func animation(newTransform: CGAffineTransform, completion: ((Bool) -> Void)? = nil) {
        superview?.layoutIfNeeded()
        UIView.animate(withDuration: Constants.animationDuration,
                       delay: Constants.animationDelay,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            self?.snackBarView.transform = newTransform
            self?.superview?.layoutIfNeeded()
        }, completion: completion)

    }

    private func invalidDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
}


