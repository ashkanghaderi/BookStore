//
//  HeaderSupplementaryView.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit
import SnapKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
    //MARK: UI Elements
   
    private let headerLabel = UILabel.makeLabel(
        text: "Top Books",
        font: .openSansBold(ofSize: 20),
        textColor: .elements
    )
    private let seeMoreButton = UIButton.makeButton(text: "see more", buttonColor: .clear, tintColor: .elements, borderWidth: 0)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        
        addSubview(headerLabel)
        addSubview(seeMoreButton)
        setConstraints()
        
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Header Configure
    
    func configureHeader(categoryName: String) {
        headerLabel.text = categoryName
    }
    
    // MARK: - Setup Constraints
    
    private func setConstraints() {
        seeMoreButton.snp.makeConstraints { make in
            make.width.equalTo(62)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(headerLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc func seeMoreButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.seeMoreButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.seeMoreButton.transform = CGAffineTransform.identity
            })
        })
    }
}
