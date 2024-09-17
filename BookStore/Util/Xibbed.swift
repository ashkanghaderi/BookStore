//
//  Xibbed.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit

protocol Xibbed {}

extension Xibbed where Self: UIView {
    @discardableResult
    func xibSetup(xibName: String? = nil) -> UIView {
        let view = loadViewFromNib(xibName: xibName)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)

        return view
    }

    @discardableResult
    func loadViewFromNib(xibName: String?) -> UIView {
        let fullName = NSStringFromClass(self.classForCoder)
        let name = xibName ?? fullName.components(separatedBy: ".")[1]
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }
        return view
    }

    func commit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: Self.self), bundle: bundle)
        let views = nib.instantiate(withOwner: self, options: nil)
        guard let view = views.first as? UIView else {return}
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}


