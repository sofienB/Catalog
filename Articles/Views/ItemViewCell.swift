//
//  ItemViewCell.swift
//  Articles
//
//  Created by Sofien Benharchache on 16/11/2022.
//

import UIKit

// Declare a custom key for a custom `item` property.
fileprivate extension UIConfigurationStateCustomKey {
    static let chip = UIConfigurationStateCustomKey("com.articles.ChipCell.chip")
}

// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {
    var chip: ChipLabel? {
        set { self[.chip] = newValue }
        get { return self[.chip] as? ChipLabel }
    }
}

class ChipCell: UICollectionViewCell {
    private var chip: ChipLabel? = nil
    
    func updateWithChip(_ newChip: ChipLabel) {
        guard chip != newChip else { return }
        chip = newChip
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.chip = self.chip
        return state
    }
}

final class CustomChipCell: ChipCell {
    
    private func defaultListContentConfiguration() -> UIListContentConfiguration { return .subtitleCell() }
    private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())

    var isConfigured = false
    
    private func setupViewsIfNeeded() {
        // We only need to do anything if we haven't already setup the views and created constraints.
        guard !isConfigured else { return }
        
        contentView.addSubview(listContentView)
        
        listContentView.translatesAutoresizingMaskIntoConstraints = false
        let defaultHorizontalCompressionResistance = listContentView.contentCompressionResistancePriority(for: .horizontal)
        listContentView.setContentCompressionResistancePriority(defaultHorizontalCompressionResistance - 1, for: .horizontal)
        
        NSLayoutConstraint.activate([
            listContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            listContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        isConfigured = true
    }
    
    /// - Tag: UpdateConfiguration
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        // Configure the list content configuration and apply that to the list content view.
        var content = defaultListContentConfiguration().updated(for: state)
        content.text = state.chip?.text
        content.axesPreservingSuperviewLayoutMargins = []
        listContentView.configuration = content

        //let color = UIColor.purple
        let color = UIColor
            .hexColor("#8D99AE")
            .withAlphaComponent(0.4)
        
        // Text content
        content.textProperties.color = color
        content.textProperties.alignment = .center
        content.attributedText = NSAttributedString(string: "Text", attributes: [
               .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
           ])
        
        // Border
        listContentView.layer.masksToBounds = true
        listContentView.layer.cornerRadius = 8.0
        listContentView.backgroundColor = color.withAlphaComponent(0.2)
        listContentView.layer.borderWidth = 1
        listContentView.layer.borderColor = color.cgColor
    }
}
