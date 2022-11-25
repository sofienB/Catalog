//
//  ItemCell.swift
//  Articles
//
//  Created by Sofien Benharchache on 22/11/2022.
//

import UIKit

typealias ItemModel = ViewController.Item

// Declare a custom key for a custom `item` property.
fileprivate extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("com.article.ItemCell.item")
}

// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {
    var item: ClassifiedAd? {
        set { self[.item] = newValue }
        get { return self[.item] as? ClassifiedAd }
    }
}

// This list cell subclass is an abstract class with a property that holds the item the cell is displaying,
// which is added to the cell's configuration state for subclasses to use when updating their configuration.
class ItemListCell: UICollectionViewListCell {
    private var item: ClassifiedAd? = nil
    
    func updateWithItem(_ newItem: ClassifiedAd) {
        guard item != newItem else { return }
        item = newItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.item = self.item
        return state
    }
}

final class ItemCell: ItemListCell {
    
    private func defaultListContentConfiguration() -> UIListContentConfiguration { return .subtitleCell() }
    private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
    
    private var cardView = ItemView()
    
    private var customViewConstraints: (cardViewCenterX: NSLayoutConstraint,
                                        cardViewCenterY: NSLayoutConstraint)?
    
    private func setupViewsIfNeeded() {
        // We only need to do anything if we haven't already setup the views and created constraints.
        guard customViewConstraints == nil else { return }
        
        contentView.addSubview(listContentView)
        contentView.addSubview(cardView)

        listContentView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let defaultHorizontalCompressionResistance = listContentView
            .contentCompressionResistancePriority(for: .horizontal)
        listContentView
            .setContentCompressionResistancePriority(defaultHorizontalCompressionResistance - 1, for: .horizontal)

        let constraints = (
            cardViewCenterX: cardView
                .centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            cardViewCenterY: cardView
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor)
        )
        NSLayoutConstraint.activate([
            listContentView
                .centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            listContentView
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),

            cardView
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor),
            cardView
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor),
            cardView
                .topAnchor
                .constraint(equalTo: contentView.topAnchor),
            cardView
                .bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor),

            constraints.cardViewCenterX,
            constraints.cardViewCenterY
        ])

        customViewConstraints = constraints

        cardView.configureConstraints()
    }

    /// - Tag: UpdateConfiguration
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        // Configure the list content configuration and apply that to the list content view.
        var content = defaultListContentConfiguration().updated(for: state)
        content
            .imageProperties
            .preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)

        guard let item = state.item
        else { return }
        
        cardView.configure(title: item.title)
        cardView.configure(price: item.formattedPrice)
        cardView.configure(category: item.category)
        cardView.configureUrgentIcon( item.isUrgent)
        cardView.configure(image: item.imagesURL.smallData, withPlaceholder: UIImage(named: "placeholder"))

        guard item.imagesURL.smallData == nil
        else { return }

        Task {
            do {
                var item = item
                if let imageData = try await item.imagesURL.downloadSmall {
                    cardView.configure(image: imageData, withPlaceholder: UIImage(named: "placeholder"))
                }
            }
            catch { }
        }
    }
}
