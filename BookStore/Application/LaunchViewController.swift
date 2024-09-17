//
//  LaunchViewController.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit
import Lottie

final class LaunchViewController: UIViewController {

    lazy var animationView: LottieAnimationView = {
        let element = LottieAnimationView()
        element.animation = LottieAnimation.named("Animation - 1")
        element.loopMode = .loop
        element.contentMode = .scaleAspectFit
        return element
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConstraints()
        animationView.play()
    }

    //MARK: - Private Methods
    private func setupViews() {
        view.addSubviewsTamicOff(animationView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
            animationView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7)
        ])
    }
}
