//
//  SearchCell.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {

    static let identifier = "SearchCell"

    // MARK: UI Elements

    private lazy var genreLabel = UILabel.makeLabel(font:.openSansBold(ofSize: 10), textColor: .lightGray)

    private lazy var nameLabel = UILabel.makeMultiLineLabel(font: .openSansBold(ofSize: 14), textColor: .white, numberOfLines: 2)

    private lazy var authorLabel = UILabel.makeMultiLineLabel(font: .openSansRegular(ofSize: 10), textColor: .white, numberOfLines: 0)

    private lazy var backgroundBookView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var infoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlack
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var bookImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = nil
        nameLabel.text = nil
        authorLabel.text = nil
        bookImage.image = nil
    }

    public func configure(with doc: Doc) {
        
        if let genres = doc.subject_key, !genres.isEmpty {
            let matchingCategories = genres
                .compactMap { Categories(rawValue: $0.lowercased()) }
                .shuffled()

            var selectedCategories: [Categories] = []

            if matchingCategories.count >= 2 {
                selectedCategories = Array(matchingCategories.prefix(2))
            } else {
                selectedCategories = matchingCategories
            }

            if selectedCategories.isEmpty {
                self.genreLabel.text = "Unknown Genre"
            } else {
                let genreLabels = selectedCategories.map { $0.rawValue.capitalized }
                self.genreLabel.text = genreLabels.joined(separator: ", ")
            }
        } else {
            self.genreLabel.text = "Unknown Genre"
        }

        
        if let title = doc.title_suggest, !title.isEmpty {
                self.nameLabel.text = title
            } else {
                self.nameLabel.text = "Unknown Title"
            }
        
        if let authors = doc.author_name, !authors.isEmpty {
                self.authorLabel.text = authors.joined(separator: ", ")
            } else {
                self.authorLabel.text = "Unknown Author"
            }
        
        guard let coverId = doc.cover_i else { return }
        self.bookImage.setImage(with: "\(coverId)", and: .medium)

    }

    private func setupUI() {
        addSubviewsTamicOff(backgroundBookView)
        backgroundBookView.addSubviewsTamicOff(bookImage,infoBackgroundView)
        infoBackgroundView.addSubviewsTamicOff(genreLabel,nameLabel,authorLabel)

        genreLabel.textAlignment = .left
        nameLabel.textAlignment = .left
        authorLabel.textAlignment = .left
        
        authorLabel.lineBreakMode = .byTruncatingTail
        authorLabel.adjustsFontSizeToFitWidth = false
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.adjustsFontSizeToFitWidth = false

        NSLayoutConstraint.activate([

            backgroundBookView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBookView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBookView.heightAnchor.constraint(equalToConstant: 213),

            bookImage.topAnchor.constraint(equalTo: backgroundBookView.topAnchor, constant: 10),
            bookImage.centerXAnchor.constraint(equalTo: backgroundBookView.centerXAnchor),
            bookImage.heightAnchor.constraint(equalToConstant: 123),
            bookImage.widthAnchor.constraint(equalToConstant: 79),

            infoBackgroundView.bottomAnchor.constraint(equalTo: backgroundBookView.bottomAnchor),
            infoBackgroundView.trailingAnchor.constraint(equalTo: backgroundBookView.trailingAnchor),
            infoBackgroundView.leadingAnchor.constraint(equalTo: backgroundBookView.leadingAnchor),
            infoBackgroundView.widthAnchor.constraint(equalTo: backgroundBookView.widthAnchor),
            infoBackgroundView.heightAnchor.constraint(equalToConstant: 88),

            genreLabel.leadingAnchor.constraint(equalTo: infoBackgroundView.leadingAnchor,constant: 10),
            genreLabel.widthAnchor.constraint(equalTo: infoBackgroundView.widthAnchor, constant: -10),
            genreLabel.topAnchor.constraint(equalTo: infoBackgroundView.topAnchor, constant: 10),

            nameLabel.leadingAnchor.constraint(equalTo: infoBackgroundView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: infoBackgroundView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor),

            authorLabel.leadingAnchor.constraint(equalTo: infoBackgroundView.leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: infoBackgroundView.trailingAnchor, constant: -10),
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            authorLabel.bottomAnchor.constraint(equalTo: infoBackgroundView.bottomAnchor, constant: -10),
        ])
    }
}
