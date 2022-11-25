//
//  ItemView.swift
//  Articles
//
//  Created by Sofien Benharchache on 16/11/2022.
//

import UIKit

final class ItemView: UIView {

    // Image on top view
    var imageView = UIImageView()
    
    // Title on bottom view
    var title = UILabel()
    
    // Chip price on right top view
    var price = ChipLabel()
    
    // Chip category centered between image and title
    var category = ChipLabel()
    
    // Chip urgent centered on bottom image. Can be hidden.
    var urgentIcon = ChipLabel()

    init() {
        super.init(frame: .zero)
        
        self.addSubview(title)
        self.addSubview(imageView)
        self.addSubview(price)
        self.addSubview(category)
        self.addSubview(urgentIcon)
        
        configureConstraints()
        configureContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemView {
    func configureContentView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.backgroundColor =
            .hexColor("#8D99AE")
            .withAlphaComponent(0.3)
    }
    
    func configure(title: String) {
        self.title.text = title
        self.title.textColor = .white
        self.title.textAlignment = .left
        self.title.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    func configure(image imageData: Data?, withPlaceholder placeholder: UIImage? = nil) {
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = imageData == nil
                        ? placeholder
                        : UIImage(data: imageData!)
    }
    
    func configure(price: String) {
        self.price.font = .systemFont(ofSize: 14, weight: .semibold)
        self.price.text = price
        self.price.textColor = .white
        self.price.textAlignment = .right
    }
    
    func configure(category: Category) {
        // Text content
        self.category.text = category.description
        self.category.textColor = .white
        self.category.textAlignment = .left
        self.category.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    func configureUrgentIcon(_ isUrgent: Bool) {
        self.urgentIcon.isHidden = !isUrgent

        let color = UIColor.black

        // Text content
        self.urgentIcon.text = NSLocalizedString("URGENT", comment: "")
        self.urgentIcon.textColor = .white
        self.urgentIcon.textAlignment = .center
        self.urgentIcon.font = .systemFont(ofSize: 12, weight: .bold)
        
        // Border and view
        self.urgentIcon.layer.masksToBounds = true
        self.urgentIcon.layer.cornerRadius = 8.0
        self.urgentIcon.backgroundColor = color.withAlphaComponent(0.4)
        self.urgentIcon.layer.borderWidth = 0.5
        self.urgentIcon.layer.borderColor = UIColor.white.cgColor
        
        // Padding
        self.urgentIcon.edgeInsets(top: .zero, left: 10, right: 10, bottom: .zero)
    }
    
    func configureConstraints() {
        let imagePadding = 7.0
        let padding = 5.0
        urgentIcon.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        category.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor,
                                          constant: imagePadding),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                              constant: imagePadding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                               constant: -imagePadding)
        ])
        
        NSLayoutConstraint.activate([
            urgentIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            urgentIcon.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,
                                              constant: -padding),
        ])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                       constant: padding),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                           constant: padding),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                            constant: -padding),
        ])

        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: title.bottomAnchor,
                                          constant: padding),
            category.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                           constant: padding),
            category.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                          constant: -padding)
        ])

        NSLayoutConstraint.activate([
            price.topAnchor.constraint(equalTo: title.bottomAnchor,
                                          constant: padding),
            price.leadingAnchor.constraint(equalTo: category.leadingAnchor),
            price.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                            constant: -padding),
            price.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                          constant: -padding)
        ])
        
        title.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        title.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        
        category.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        category.setContentCompressionResistancePriority(.defaultHigh + 2, for: .vertical)
        
        urgentIcon.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        urgentIcon.setContentCompressionResistancePriority(.defaultHigh + 3, for: .vertical)
        
        price.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        price.setContentCompressionResistancePriority(.defaultHigh + 3, for: .vertical)
    }
}
