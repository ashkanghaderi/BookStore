//
//  UIView + ext.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit

extension UIView {
    
    func addSubviewsTamicOff(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func addSwipeGestureAllDirection(action: Selector) {

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: action)
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: action)
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: action)
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: action)
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        addGestureRecognizer(swipeDown)
    }
}
