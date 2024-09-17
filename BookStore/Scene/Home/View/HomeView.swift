import UIKit
import SnapKit

protocol HomeVCProtocol: AnyObject {
    func didSelectBook(targetVC: UIViewController)
}

final class HomeView: UIView {
    
    //MARK: UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .background
        collectionView.bounces = false
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let sections = HomeModel.shared.pageData
    var bookAPI: BookAPIProtocol?
    private var trendingBooks: [TrendingBooks.Book] = []
    private var works: [CategoryCollection.Work] = []
    var selectedSegment: TrendingPeriod = .weekly {
       didSet {
           print("Selected segment changed to \(selectedSegment)")
           self.collectionView.reloadData()
       }
    }
    
    weak var delegate: HomeVCProtocol?
    private var udManager = UserDefaultsManager()
    private lazy var loadingView: LoadingIndicator = { return LoadingIndicator() }()

    // MARK: - Set Views
    
    func setViews() {
        self.backgroundColor = .background
        self.addSubview(collectionView)
        fetchTrendingBooks()
        fetchCategoryCollection()
        buttonPressed(selectedSegment: selectedSegment)
        collectionView.register(TopBooksViewCell.self,
                                forCellWithReuseIdentifier: "TopBooksCollectionViewCell")
        collectionView.register(RecentBooksViewCell.self,
                                forCellWithReuseIdentifier: "RecentBooksViewCell")
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: "headerItem",
                                withReuseIdentifier: "HeaderSupplementaryView")
        collectionView.register(CustomSegmentedControlReusableView.self,
                                forSupplementaryViewOfKind: "segmentedControl",
                                withReuseIdentifier: "SegmentedControl")
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    // MARK: - Setup Constraints
    
    func setupConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Set Delegates
    
    func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension UIStackView {
    convenience init(spacing: CGFloat, axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment) {
        self.init()
        self.spacing = spacing
        self.axis = axis
        self.alignment = alignment
    }
}

// MARK: - Create Layout

private extension HomeView {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
                
            case .topBooks(_):
                return self.createTopBookSection()
            case .recentBooks(_):
                return self.createBottomBookSection()
            }
        }
    }
    
    private func createLayoutSection(group: NSCollectionLayoutGroup,
                                     behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                                     interGroupSpacing: CGFloat,
                                     supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
                                     contentInsets: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        section.supplementariesFollowContentInsets = contentInsets
        return section
    }
    
    private func createTopBookSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(0.9)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                                         heightDimension: .fractionalHeight(0.4)),
                                                       subitems: [item])
        
        
        let segmentedControlItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .estimated(100)),
            elementKind: "segmentedControl",
            alignment: .top
        )
        
        let section = createLayoutSection(group: group,
                                          behavior: .continuous,
                                          interGroupSpacing: 10,
                                          supplementaryItems: [segmentedControlItem],
                                          contentInsets: true)
        section.contentInsets = .init(top: 0, leading: 19, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createBottomBookSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(0.9)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                                         heightDimension: .fractionalHeight(0.4)),
                                                       subitems: [item])
        
        let section = createLayoutSection(group: group,
                                          behavior: .continuous,
                                          interGroupSpacing: 10,
                                          supplementaryItems: [supplementaryHeaderItem()],
                                          contentInsets: true)
        section.contentInsets = .init(top: 0, leading: 19, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(50)),
              elementKind: "headerItem",
              alignment: .top)
    }

}

// MARK: - UICollectionViewDelegate

extension HomeView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = BookDetailsViewController()
        switch sections[indexPath.section] {

        case .topBooks(_):

            let book = trendingBooks[indexPath.row]

            let booksModel = BookDetailsModel(key: book.key ?? "",
                                              image: book.cover_i ?? 0,
                                              title: book.title ?? "Unknowed Name",
                                              authorName: book.author_name?[0] ?? "",
                                              hasFullText: book.has_fulltext ?? false,
                                              ia: book.ia?[0] ?? "" ,
                                              category: "Top Books",
                                              raiting: 0.00,
                                              descriptionText: book.first_publish_year?.description ?? "")

            udManager.addToRecent(book.key ?? "")
            print(udManager.getBook(for: UserDefaultsManager.Keys.recent))

            vc.book = booksModel

        case .recentBooks(_):
            let book = works[indexPath.row]

            let booksModel = BookDetailsModel(key: book.key ?? "",
                                              image: book.cover_id ?? 0,
                                              title: book.title ?? "Unknowed Name",
                                              authorName: book.authors.first?.name ?? "",
                                              hasFullText: book.has_fulltext ?? false,
                                              ia: book.ia ?? "" ,
                                              category: "Recent Books",
                                              raiting: 0.00,
                                              descriptionText: book.first_publish_year?.description ?? "")

            udManager.addToRecent(book.key ?? "")
            print(udManager.getBook(for: UserDefaultsManager.Keys.recent))

            vc.book = booksModel

        }

        delegate?.didSelectBook(targetVC: vc)
    }

}

// MARK: - UICollectionViewDataSource

extension HomeView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trendingBooks.prefix(10).count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .topBooks(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopBooksCollectionViewCell", for: indexPath) as? TopBooksViewCell
            else {
                return UICollectionViewCell()
            }

            let book = trendingBooks[indexPath.row]
            cell.configureCell(book: book)
            
            return cell
            
        case .recentBooks(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentBooksViewCell", for: indexPath) as? RecentBooksViewCell
            else {
                return UICollectionViewCell()
            }
            if works.indices.contains(indexPath.row) {
                let work = works[indexPath.row]
                cell.configureCell(work: work)
            }

            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case "headerItem":
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: "HeaderSupplementaryView",
                                                                            for: indexPath) as? HeaderSupplementaryView {
                header.configureHeader(categoryName: sections[indexPath.section].title)
                return header
                
            } else {
                return UICollectionReusableView()
            }
            
        case "segmentedControl":
            if let segmentedControl = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: "SegmentedControl",
                                                                                      for: indexPath) as? CustomSegmentedControlReusableView {
                segmentedControl.segmentedControl.delegate = self
                return segmentedControl
            } else {
                return UICollectionReusableView()
            }
            
        default:
            return UICollectionReusableView()
        }
    }
    
    // MARK: - Networking
    
    private func fetchTrendingBooks() {
        loadingView.show()
        Task { [weak self] in
            guard let self else { return }
            do {
                if let data = try await bookAPI?.getTrendingBooks(for: self.selectedSegment) {
                    self.trendingBooks = data
                    self.loadingView.dismiss()
                    self.collectionView.reloadData()
                }
            } catch {
                self.loadingView.dismiss()
                SnackBar.make(message: error.localizedDescription, duration: .short)
                    .setStyle(with: .error)
                    .show()
            }
        }
    }

    private func fetchCategoryCollection() {
        loadingView.show()
        Task { [weak self] in
            guard let self else { return }
            do {
                if let data = try await bookAPI?.getCategoryCollection(for: .fiction), let works = data.first {
                    self.loadingView.dismiss()
                    self.works = works.works
                    self.collectionView.reloadData()
                }
            } catch {
                self.loadingView.dismiss()
                SnackBar.make(message: error.localizedDescription, duration: .short)
                    .setStyle(with: .error)
                    .show()
            }
        }
    }
    
    func updateCollection(for selectedSegment: TrendingPeriod) {
      fetchTrendingBooks()
    }
 
}

// MARK: - SegmentedControl delegate

extension HomeView: CustomSegmentedControlDelegate {
   func buttonPressed(selectedSegment: TrendingPeriod) {
       self.selectedSegment = selectedSegment
       trendingBooks.removeAll()
       fetchTrendingBooks()
   }
}
