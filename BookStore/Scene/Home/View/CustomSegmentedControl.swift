//
//  CustomSegmentedControl.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit

final class CustomSegmentedControl: UIView {

    private var selectedSegment: TrendingPeriod = .weekly

    //MARK: UI Elements
    
    private var verticalContainer: UIView = UIView()
    private var buttonsContainer: UIStackView = UIStackView()
    
    private var buttons: [UIButton] = []
    private var buttonTitles: [String] = []
    
    private var barView: UIView = UIView()
    private var barViewLeadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var selectedButtonIndex: Int = 0
    
    private var elementsTintColor: UIColor = UIColor()
    private var fontSelected: UIFont = UIFont()
    private var fontUnselected: UIFont = UIFont()
    
    // MARK: - CustomSegmentedControlDelegate
    
    weak var delegate: CustomSegmentedControlDelegate?
    
    convenience init(buttonTitles: [String], selectedSegment: TrendingPeriod, tintColor: UIColor = .black, fontSelected: UIFont = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold)), fontUnselected: UIFont = .preferredFont(forTextStyle: .body)) {
        self.init()
        
        guard buttonTitles.isEmpty == false else { return }
        self.buttonTitles = buttonTitles
        self.selectedSegment = selectedSegment
        self.fontSelected = fontSelected
        self.fontUnselected = fontUnselected
        self.tintColor = tintColor
        configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        addViews()
        prepareVContainer()
        prepareButtons()
        prepareButtonsContainer()
        prepareBarView()
    }
    
    private func addViews() {
        addSubview(verticalContainer)
    }
    
    private func prepareVContainer() {
        verticalContainer.translatesAutoresizingMaskIntoConstraints = false
        verticalContainer.addSubview(buttonsContainer)
        verticalContainer.addSubview(barView)
        
        NSLayoutConstraint.activate([
            verticalContainer.topAnchor.constraint(equalTo: topAnchor),
            verticalContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            bottomAnchor.constraint(equalTo: barView.bottomAnchor)
        ])
    }
    
    private func prepareButtons() {
        buttons = buttonTitles.map { title in
            let button: UIButton = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tintColor = .black
            button.titleLabel?.font = fontUnselected
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            return button
        }
        buttons[0].setTitleColor(tintColor, for: .normal)
        buttons[0].titleLabel?.font = fontSelected
    }
    
    private func prepareButtonsContainer() {
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.axis = .horizontal
        buttonsContainer.distribution = .fillEqually
        buttonsContainer.spacing = 30
        
        buttons.forEach {
            buttonsContainer.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            buttonsContainer.topAnchor.constraint(equalTo: verticalContainer.topAnchor),
            buttonsContainer.leadingAnchor.constraint(equalTo: verticalContainer.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: verticalContainer.trailingAnchor),
        ])
    }
    
    private func prepareBarView() {
        let firstButton = buttons[0]
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = tintColor
        barViewLeadingConstraint = barView.leadingAnchor.constraint(equalTo: firstButton.leadingAnchor)
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: buttonsContainer.bottomAnchor, constant: 5),
            barView.widthAnchor.constraint(equalTo: firstButton.widthAnchor),
            barView.heightAnchor.constraint(equalToConstant: 4),
            barViewLeadingConstraint
        ])
    }
    
    
    
    // MARK: - Actions
    
    @objc private func buttonAction(sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        
    
        switch buttonIndex {
        case 0:
            selectedSegment = .weekly
          
        case 1:
            selectedSegment = .monthly
          
        case 2:
            selectedSegment = .yearly
       
        default:
            break
        }
        
        print("Selected segment: \(selectedSegment)")
        selectedButtonIndex = buttonIndex
        prepareButtonsUI()
        animateBarViewPosition()
        
        delegate?.buttonPressed(selectedSegment: selectedSegment)
    }
    
    private func prepareButtonsUI() {
        let selectedButton = buttons[selectedButtonIndex]
        buttons.forEach { button in
            if button == selectedButton {
                button.setTitleColor(tintColor, for: .normal)
                button.titleLabel?.font = fontSelected
            } else {
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = fontUnselected
            }
        }
    }
    
    private func animateBarViewPosition() {
        let selectedButton = buttons[selectedButtonIndex]
        barViewLeadingConstraint.isActive = false
        barViewLeadingConstraint = barView.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)
        barViewLeadingConstraint.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
