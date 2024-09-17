//
//  UIImageView Extension.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import Kingfisher
import UIKit
import SkeletonView

extension UIImageView {

    enum ImageSize: String {
        case small
        case medium
        case large
    }


    func setImage(with coverId: String, and size: ImageSize? = .medium) {
        var sizeStr = "M"
        switch size {
        case .large:
            sizeStr = "L"
        case .medium:
            sizeStr = "M"
        case .small:
            sizeStr = "S"
        default:
            sizeStr = "M"
        }
        guard let imageUrl = URL(string: "https://covers.openlibrary.org/b/id/" + "\(coverId)-\(sizeStr).jpg") else {
            self.image = UIImage(named: "")
            return
        }

        let cacheExists = ImageCache.default.isCached(forKey: imageUrl.absoluteString)

        if !cacheExists {
            addSkeletonGradient()
        }

        self.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(1))]) { [weak self] completion in
            guard let self else { return }
            self.hideSkeleton()
        }
    }

    func addSkeletonGradient() {
        isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: UIColor.clouds)
        showGradientSkeleton(usingGradient: gradient,
                             animated: true,
                             delay: 0)
    }
}

