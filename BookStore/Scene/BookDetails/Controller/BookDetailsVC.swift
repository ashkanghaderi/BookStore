//
//  BookDetailsViewController.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit
import Kingfisher

final class BookDetailsViewController: UIViewController {

    private var udManager = UserDefaultsManager()
    
    //MARK: - Dependencies
    let spacing: CGFloat = 24
    let labelHeight: CGFloat = 20
    
    var book = BookDetailsModel(key: "",
                                image: 0,
                                title: "",
                                authorName: "",
                                hasFullText: true,
                                ia: "",
                                category: "",
                                raiting: 0.00,
                                descriptionText: "no description")
    
    //MARK: - UI Elements
    
    private lazy var topLabel: UILabel = {
        let element = UILabel()
        element.text = book.title
        element.textAlignment = .center
        element.font = UIFont.openSansBold(ofSize: 24)
        element.adjustsFontSizeToFitWidth = true
        element.numberOfLines = 0
        return element
    }()
    
    private lazy var mainStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .fillEqually
        element.spacing = 20
        return element
    }()
    
    private lazy var rightStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.distribution = .fillEqually
        element.alignment = .leading
        element.spacing = 50
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var labelsStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.distribution = .fillEqually
        element.alignment = .leading
        element.spacing = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.distribution = .fillEqually
        element.alignment = .leading
        element.spacing = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var leftStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.distribution = .equalSpacing
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var bookCover: UIImageView = {
        let element = UIImageView()
        element.setImage(with: "\(book.image)", and: .large)
        element.contentMode = .scaleAspectFit
        return element
    }()

    
    private lazy var starButton: UIButton = {
        let element = UIButton()
        element.imageView?.contentMode = .scaleAspectFill
        element.setImage(
            UIImage(
                systemName: "star.square"
            )?.withConfiguration(
                UIImage.SymbolConfiguration(
                    pointSize: 40
                )
            ),
            for: .normal
        )
        element.tintColor = .white
        element.translatesAutoresizingMaskIntoConstraints = false
        element.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
        return element
    }()
    

    lazy var authorLabel = UILabel(text1: "Author: ", text2: book.authorName)
    lazy var categoryLabel = UILabel(text1: "Category: ", text2: book.category)
    private lazy var raitingLabel = UILabel(text1: "Raiting: ", text2: "\(book.raiting) / 5")
    
    var descriptionLabel: UILabel = {
        let element = UILabel()
        element.text = "Description:"
        element.font = UIFont.openSansBold(ofSize: 14)
        return element
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let element = UITextView()
        element.isScrollEnabled = true
        element.text = book.descriptionText
        element.font = UIFont.openSansRegular(ofSize: 14)
        element.backgroundColor = .clear
        
        DispatchQueue.main.async {
            element.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        }
        
        return element
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setStack()
        setConstraints()
    }
    
    //MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = UIColor.background
        view.addSubviewsTamicOff(
            topLabel,
            mainStack,
            descriptionLabel,
            descriptionTextView
        )
    }
    
    private func setStack() {
        mainStack.addArrangedSubview(leftStack)
        mainStack.addArrangedSubview(rightStack)
        
        leftStack.addArrangedSubview(bookCover)
        leftStack.addSubview(starButton)
        rightStack.addArrangedSubview(labelsStack)
        rightStack.addArrangedSubview(buttonsStack)
        
        labelsStack.addSubviewsTamicOff(authorLabel, categoryLabel, raitingLabel)
    }
    
    @objc private func starButtonAction() {
        udManager.addBookToFavorites(book.key, category: .likedBooks)
    }
}

//MARK: - Constraints
private extension BookDetailsViewController {
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            
            mainStack.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: spacing),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            mainStack.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: spacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            labelsStack.heightAnchor.constraint(equalTo: rightStack.heightAnchor, multiplier: 0.5),
            buttonsStack.heightAnchor.constraint(equalTo: rightStack.heightAnchor, multiplier: 0.5),
            
            authorLabel.topAnchor.constraint(equalTo: rightStack.topAnchor, constant: 30),
            categoryLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            raitingLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            
            rightStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -10),

            labelsStack.leadingAnchor.constraint(equalTo: rightStack.leadingAnchor),
            labelsStack.trailingAnchor.constraint(equalTo: rightStack.trailingAnchor),
            labelsStack.topAnchor.constraint(equalTo: rightStack.topAnchor),
            
            authorLabel.trailingAnchor.constraint(equalTo: labelsStack.trailingAnchor, constant: -10),
            categoryLabel.trailingAnchor.constraint(equalTo: labelsStack.trailingAnchor, constant: -10),
            raitingLabel.trailingAnchor.constraint(equalTo: labelsStack.trailingAnchor, constant: -10),
            authorLabel.leadingAnchor.constraint(equalTo: labelsStack.leadingAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: labelsStack.leadingAnchor, constant: 10),
            raitingLabel.leadingAnchor.constraint(equalTo: labelsStack.leadingAnchor, constant: 10),
            
            buttonsStack.leadingAnchor.constraint(equalTo: rightStack.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: rightStack.trailingAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: rightStack.bottomAnchor),
            
            starButton.topAnchor.constraint(equalTo: bookCover.topAnchor, constant: 16),
            starButton.trailingAnchor.constraint(equalTo: bookCover.trailingAnchor),
            starButton.heightAnchor.constraint(equalToConstant: 32),
            starButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
}

//MARK: - Convenience Inits
private extension UILabel {
    convenience init(text1: String, text2: String) {
        self.init()
        let regularFont = UIFont.openSansRegular(ofSize: 14)
        let boldFont = UIFont.openSansBold(ofSize: 14)
        let attributedText = NSMutableAttributedString(
            string: text1,
            attributes: [.font: regularFont ?? UIFont.systemFont(ofSize: 14),
                         .foregroundColor: UIColor.labelColors])
        let categoryText = NSAttributedString(
            string: text2,
            attributes: [.font: boldFont ?? UIFont.boldSystemFont(ofSize: 14),
                         .foregroundColor: UIColor.labelColors])
        attributedText.append(categoryText)
        self.attributedText = attributedText
        self.numberOfLines = 0
    }
}
