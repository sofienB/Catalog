//
//  ViewController.swift
//  Articles
//
//  Created by Sofien Benharchache on 14/11/2022.
//

import UIKit

final class ViewController: UIViewController {
    
    private var catalog = [ClassifiedAd]()
    private var category = Category.unknown
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureNavItem()
        configureHierarchy()
        configureDataSource()
        performQuery()
    }
}

extension ViewController {
    // Section
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case category, catalog
        
        var description: String {
            switch self {
            case .category: return NSLocalizedString("category", comment: "")
            case .catalog: return NSLocalizedString("catalog", comment: "")
            }
        }
    }
    
    // Item
    struct Item: Hashable {
        var category: Category?
        var catalog: ClassifiedAd?
        let identifier = UUID()

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func ==(lhs: Item, rhs: Item) -> Bool {
            return lhs.identifier == rhs.identifier && lhs.category == rhs.category && lhs.catalog == rhs.catalog
        }
    }
}

extension ViewController {
    private func fetchData() {
        // From Networking
        Networking.fetchCatalogData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let classifiedAds):
                    self?.handle(success: classifiedAds)
                case .failure(let resultError):
                    self?.handle(error: resultError)
                }
            }
        }

        // From local file
        /*if let data = Networking.localFile(name: "listing") {
            Networking.decode(data: data, toType: [ClassifiedAd].self) {
                [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let classifiedAds):
                        print("SUCCESSSSS !!!")
                        self?.handle(success: classifiedAds)
                    case .failure(let resultError):
                        self?.handle(error: resultError)
                    }
                }
            }
        }*/
    }
    
    func configureNavItem() {
        navigationItem.title = NSLocalizedString("catalog", comment: "")
        navigationItem.largeTitleDisplayMode = .always
    }

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainBlue
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    /// - Tag: CreateFullLayout
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            // category
            if sectionKind == .category {
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.5),
                    heightDimension: .estimated(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .estimated(100),
                        heightDimension: layoutSize.heightDimension
                    ),
                    subitems: [.init(layoutSize: layoutSize)]
                )
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
            // catalog
            } else if sectionKind == .catalog {
                let environmentWidth = layoutEnvironment.container.effectiveContentSize.width
                let columns = environmentWidth < 500 ? 2
                            : environmentWidth < 800 ? 4
                            : environmentWidth < 1200 ? 5
                            : 7
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5,
                                                             bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(250))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitem: item, count: columns)
                section = NSCollectionLayoutSection(group: group)
            } else {
                fatalError("Unknown section!")
            }
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    func createOutlineHeaderCellRegistration() -> UICollectionView.CellRegistration<CustomChipCell, Category> {
        return UICollectionView.CellRegistration<CustomChipCell, Category>
        { (cell, indexPath, category) in
            let chip = ChipLabel()
            chip.text = category.description
            cell.updateWithChip(chip)
        }
    }

    /// - Tag: ConfigureListCell
    func createListCellRegistration() -> UICollectionView.CellRegistration<ItemCell, ClassifiedAd> {
        return UICollectionView.CellRegistration<ItemCell, ClassifiedAd>
        { (cell, indexPath, article) in
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
            cell.updateWithItem(article)
        }
    }
    
    /// - Tag: DequeueCells
    func configureDataSource() {
        // create registrations up front, then choose the appropriate one to use in the cell provider
        let listCellRegistration = createListCellRegistration()
        let gridCellRegistration = createOutlineHeaderCellRegistration()
        
        // data source
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section)
            else { fatalError("Unknown section") } // fataError should never be called.
            
            switch section {
            case .category:
                guard let category = item.category
                else { fatalError("Unknown section - category") }
                
                return collectionView.dequeueConfiguredReusableCell(
                    using: gridCellRegistration,
                    for: indexPath,
                    item: category)
            case .catalog:
                guard let catalog = item.catalog
                else { fatalError("Unknown section - catalog") }
                
                return collectionView.dequeueConfiguredReusableCell(
                    using: listCellRegistration,
                    for: indexPath,
                    item: catalog)
            }
        }
    }
    
    /// - Tag: SectionSnapshot
    func performQuery() {
        // Category list never changed
        let categoryItem = Category.allCases.map { Item(category: $0) }

        // catalog can be sort by category
        let catalogItem: [Item]
        if category == .unknown { // if category == .unknown so get all values.
            catalogItem = catalog.map { Item(catalog: $0) }
        } else { // else get sub catalog by spesific category.
             catalogItem = catalog.sub(category: category).map { Item(catalog: $0) }
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.category])
        snapshot.appendSections([.catalog])
        snapshot.appendItems(categoryItem, toSection: .category)
        snapshot.appendItems(catalogItem, toSection: .catalog)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Collection Handler
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // update list
            self.category = Category(rawValue:indexPath.row) ?? .unknown
            performQuery()
            break
        case 1: // Go to detail view
            guard let article = self.dataSource.itemIdentifier(for: indexPath)?.catalog else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            let detailViewController = ArticleDetailViewController()
            detailViewController.configure(article)
            detailViewController.modalPresentationStyle = .fullScreen
            self.show(detailViewController, sender: nil)
        default:
            break
        }
    }
}

// MARK: - Networking handler.
extension ViewController {
    
    // Update catalogue.
    // Sort catalogue.
    func handle(success classifiedAds: [ClassifiedAd]) {
        self.catalog = classifiedAds
        self.catalog.sort()
        performQuery()
    }
    
    /// Handle error
    ///
    /// - Parameter error: handled
    func handle(error: NetworkingError) {
        switch error {
        case .request(error: _): showAlertError(message: NSLocalizedString("request", comment:""))
        case .timedOut: showAlertError(message: NSLocalizedString("timedOut", comment:""))
        case .invalidUrl: showAlertError(message: NSLocalizedString("invalidUrl", comment:""))
        case .dataNotFound: showAlertError(message: NSLocalizedString("decodedError", comment:""))
        case .decoded(error: _): showAlertError(message: NSLocalizedString("error", comment:""))
        case .unknown(error: _): showAlertError()
        }
    }
    
    func showAlertError(message: String? = nil) {
        let alertTitle = NSLocalizedString("Alert", comment:"")
        let alertMessage = message == nil
            ? NSLocalizedString("anErrorOccured", comment:"An error occured")
            : message

        let alertCtrl = UIAlertController(title: alertTitle,
                                        message: alertMessage,
                                        preferredStyle: .alert)
        
        let okButton = NSLocalizedString("OK", comment:"")
        alertCtrl.addAction(UIAlertAction(title: okButton, style: .default))

        self.present(alertCtrl, animated: true, completion: nil)
    }
}
