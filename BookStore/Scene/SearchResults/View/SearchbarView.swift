//
//  SearchBarVC.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit
import SnapKit

protocol SearchBarVCDelegate: AnyObject {
    func searchButtonClicked(withRequest text: String)
    func searchCancelButtonClicked()
}

class SearchbarView: UIView {
    
    weak var delegate: SearchBarVCDelegate?

    // MARK: - UI Elements

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .label
        searchBar.barTintColor = .clear
        searchBar.layer.cornerRadius = 5
        searchBar.clipsToBounds = true
        searchBar.showsCancelButton = false
        
        // Customizing the text field
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = .elements
            searchTextField.font = .openSansRegular(ofSize: 14)
            searchTextField.backgroundColor = .clear
            searchTextField.borderStyle = .none
            searchTextField.leftView?.tintColor = .elements
            searchTextField.leftViewMode = .always
        }
        return searchBar
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: Private Methods

    private func setupUI() {
        addSubviewsTamicOff(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

// MARK: - UISearchBarDelegate
extension SearchbarView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            let vc = SearchResultVC()
            vc.searchRequest = text
            self.delegate?.searchButtonClicked(withRequest: text)
            searchBar.resignFirstResponder()
        } else {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        self.delegate?.searchCancelButtonClicked()
    }
}
