//
//  UICollectionView Extension.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-18.
//

import UIKit

extension UICollectionView {
    
    func reloadData(completion:@escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: reloadData) { _ in completion() }
    }
}
