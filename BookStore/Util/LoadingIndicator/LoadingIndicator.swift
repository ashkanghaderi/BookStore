//
//  LoadingIndicator.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit
import Lottie

final class LoadingIndicator: UIView, Xibbed {

    enum Constants {
        static let loadingAnimationSpeed = 1.0
        static let animationDuration = 0.3
        static let loadingResource = "Please Wait..."
        static let cornerRaduis = 20.0
    }

    @IBOutlet private var animationView: LottieAnimationView!
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var loadingTitle: UILabel!
    @IBOutlet private var waitingLabel: UILabel!

    private (set) var isAnimating = false

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        xibSetup()
        setupUI()
    }

    private func setupUI() {
        loadingView.layer.cornerRadius = Constants.cornerRaduis
        setupAnimation()
        alpha = 0.0
        loadingTitle.text = Constants.loadingResource
    }

    private func setupAnimation() {
        animationView.backgroundBehavior = .continuePlaying
        animationView.backgroundColor = .clear
        animationView?.pause()
        animationView?.animation = LottieAnimation.named("Loading")
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = Constants.loadingAnimationSpeed
        animationView?.play()
    }

    func show(in view: UIView? = UIApplication.shared.currentUIWindow()) {
        guard let view = view, !isAnimating else { return }
        isAnimating.toggle()
        frame = view.bounds
        view.addSubview(self)
        startAnimating()
    }

    func dismiss(animated: Bool = true) {
        if animated {
            stopAnimating()
        } else {
            removeFromSuperview()
            alpha = 0.0
            isAnimating = false
        }
    }

    func dismiss(afterDelay: TimeInterval, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay, execute: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: animated)
        })
    }

    func setTitle(with text: String) {
        waitingLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [.font: UIFont.openSansBold(ofSize: 18)!,
                         .foregroundColor: UIColor.white])
    }

    private func startAnimating() {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self = self else { return }
            self.animationView?.play()
            self.alpha = 1.0
        }
    }

    private func stopAnimating() {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self = self else { return }
            self.animationView?.pause()
            self.alpha = 0.0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
            self.isAnimating = false
        }
    }
}
