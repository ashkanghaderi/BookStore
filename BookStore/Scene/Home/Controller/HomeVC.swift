import UIKit
import SnapKit

final class HomeVC: UIViewController {

    private var udManager = UserDefaultsManager()

    // MARK: - UI Elements

    private let homeView = HomeView()

    private lazy var search =  SearchbarView()
    private let bookAPI = BookAPI()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        search.delegate = self
        homeView.delegate = self

        view.addSubviewsTamicOff(homeView,search)
        
        setupConstraints()
        
        homeView.setViews()
        homeView.setupConstraints()
        homeView.setDelegates()
        homeView.bookAPI = bookAPI

        print(udManager.getBook(for: UserDefaultsManager.Keys.recent))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Private Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super .touchesBegan(touches, with: event)
    }

    private func setupConstraints() {
        
        let offset: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            
            homeView.topAnchor.constraint(equalTo: search.bottomAnchor, constant: offset),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            search.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            search.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            search.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            search.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

// MARK: - Delegates
extension HomeVC: SearchBarVCDelegate {
    func searchCancelButtonClicked() {
        self.search.endEditing(true)
        self.search.resignFirstResponder()
    }
    
    func searchButtonClicked(withRequest text: String) {
        let vc = SearchResultVC()
        vc.searchRequest = text
        vc.bookAPI = bookAPI
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: HomeVCProtocol {
    func didSelectBook(targetVC: UIViewController) {
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
