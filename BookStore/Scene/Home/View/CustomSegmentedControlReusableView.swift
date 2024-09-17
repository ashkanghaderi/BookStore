//
//  CustomSegmentedControlReusableView.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit
import SnapKit

final class CustomSegmentedControlReusableView: UICollectionReusableView {
    
    //MARK: UI Elements
    
    private let headerLabel = UILabel.makeLabel(
        text: "Top Books",
        font: .openSansBold(ofSize: 20),
        textColor: .elements
    )
    private let seeMoreButton = UIButton.makeButton(text: "see more", buttonColor: .clear, tintColor: .elements, borderWidth: 0)
    
    private var selectedSegment: TrendingPeriod = .weekly

    
    private let buttonTitles: [String] = ["This Week", "This Month", "This Year"]
    lazy var segmentedControl: CustomSegmentedControl = CustomSegmentedControl(buttonTitles: buttonTitles, selectedSegment: selectedSegment)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        segmentedControl.delegate = self
        
        print(selectedSegment)
        
        backgroundColor = .background
        addSubview(segmentedControl)
        
        addSubview(headerLabel)
        addSubview(seeMoreButton)
        
        setConstraints()
        
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        
    }
    
    func configureHeader(categoryName: String) {
        headerLabel.text = categoryName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Constraints
    
    private func setConstraints() {
        
        seeMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            
        }
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(50)
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

extension CustomSegmentedControlReusableView: CustomSegmentedControlDelegate {
    func buttonPressed(selectedSegment: TrendingPeriod) {
        self.selectedSegment = selectedSegment
    }
}

