//
//  ArticleDetailViewController.swift
//  Articles
//
//  Created by Sofien Benharchache on 24/11/2022.
//

import UIKit

final class ArticleDetailViewController: UIViewController {
    
    // Visible Data
    private let coverImg : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
      }()
    
    private let descriptionLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private let creationDateLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private let categoryLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private let urgentLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private let priceLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private let siretLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private lazy var idLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    private lazy var descriptionTitleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    // Container
    private let headerView = UIView()
    
    private lazy var headerContainerView: UIView = {
      let scrollView = UIView()
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    

    private lazy var scrollView: UIScrollView = {
      let scrollView = UIScrollView()
        scrollView.backgroundColor = .mainBlue
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.alignment = .leading
      stackView.spacing = 10
      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Detail", comment: "")
        
        configureView()
        configureConstraints()
    }
    
    // Data
    func configure(_ article: ClassifiedAd) {
        var article = article
        titleLbl.text = article.title
        titleLbl.setDetailFont(.bold, size: 21)
        titleLbl.numberOfLines = 0
        
        siretLbl.text = article.siret != nil
                        ? NSLocalizedString("Pro (siret): \(article.siret ?? "")", comment: "")
                        : NSLocalizedString("Est un particulier", comment: "")
        siretLbl.setDetailFont(.light, size: 14)

        priceLbl.text = String(article.formattedPrice) + ""
        priceLbl.setDetailFont(.heavy)

        creationDateLbl.text = article.date?.formattedDate ?? ""
        creationDateLbl.setDetailFont(.semibold, size: 14)

        urgentLbl.text = article.isUrgent ? NSLocalizedString("Urgent", comment: "") : ""
        urgentLbl.setDetailFont(.semibold)

        descriptionLbl.text = article.description
        descriptionLbl.setDetailFont(.semibold)
        descriptionLbl.numberOfLines = 0
        categoryLbl.text = NSLocalizedString("Categorie : \(article.category.description)", comment: "")
        categoryLbl.setDetailFont(.semibold)

        idLbl.text = NSLocalizedString("Ref : \(article.id)", comment: "")
        idLbl.setDetailFont(.light, size: 14)
        idLbl.textAlignment = .right
        
        descriptionTitleLbl.text = NSLocalizedString("Description", comment: "")
        descriptionTitleLbl.setDetailFont(.black)
        
        coverImg.layer.cornerRadius = 10
        coverImg.layer.masksToBounds = true
        if let smallData = article.imagesURL.smallData {
            coverImg.image = UIImage(data: smallData)
        } else {
            coverImg.image = UIImage(named: "placeholder")
            Task {
                do {
                    let imageData = try await article.imagesURL.downloadSmall
                    if let imageData {
                        coverImg.image = UIImage(data: imageData)
                    }
                } catch {}
            }
        }
    }
    
    private func configureHeader() {
        headerView.addSubview(headerContainerView)
        
        headerContainerView.addSubview(priceLbl)
        headerContainerView.addSubview(categoryLbl)
        headerContainerView.addSubview(creationDateLbl)
        headerContainerView.addSubview(coverImg)
        headerContainerView.addSubview(siretLbl)
        
        headerView.backgroundColor = .white.withAlphaComponent(0.1)
        headerView.layer.cornerRadius = 6
    }
    
    // View
    private func configureView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(idLbl)
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(descriptionTitleLbl)
        stackView.addArrangedSubview(descriptionLbl)

        configureHeader()
    }
    
    private func configureConstraints() {
        // Containers
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16), // A garder ?
        ])
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            headerView.topAnchor.constraint(equalTo: stackView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        ])

        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([headerContainerView.widthAnchor.constraint(equalToConstant: 500)])
        } else {
            NSLayoutConstraint.activate([headerContainerView.widthAnchor.constraint(equalTo: headerView.widthAnchor)])
        }
        
        NSLayoutConstraint.activate([
            headerContainerView.heightAnchor.constraint(equalTo: headerView.heightAnchor),
            headerContainerView.topAnchor.constraint(equalTo: headerView.topAnchor),
            
            headerContainerView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerContainerView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        
        // Header
        let pading = 18.0
        NSLayoutConstraint.activate([
            coverImg.widthAnchor.constraint(equalToConstant: 150),
            coverImg.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: pading),
            coverImg.leftAnchor.constraint(equalTo: headerContainerView.leftAnchor, constant: pading),
            coverImg.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -pading),
        ])

        NSLayoutConstraint.activate([
            priceLbl.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: pading+10),
            priceLbl.leftAnchor.constraint(equalTo: coverImg.rightAnchor, constant: 16),
            priceLbl.rightAnchor.constraint(equalTo: headerContainerView.rightAnchor,  constant: -pading),
        ])
        
        NSLayoutConstraint.activate([
            creationDateLbl.topAnchor.constraint(equalTo: priceLbl.bottomAnchor, constant: pading*2),
            creationDateLbl.leftAnchor.constraint(equalTo: coverImg.rightAnchor, constant: 16),
            creationDateLbl.rightAnchor.constraint(equalTo: headerContainerView.rightAnchor, constant: -pading),
        ])
        
        NSLayoutConstraint.activate([
            categoryLbl.topAnchor.constraint(equalTo: creationDateLbl.bottomAnchor, constant: 8),
            categoryLbl.leftAnchor.constraint(equalTo: coverImg.rightAnchor, constant: 16),
            categoryLbl.rightAnchor.constraint(equalTo: headerContainerView.rightAnchor, constant: -pading),
        ])

        NSLayoutConstraint.activate([
            siretLbl.topAnchor.constraint(equalTo: categoryLbl.bottomAnchor, constant: 8),
            siretLbl.leftAnchor.constraint(equalTo: coverImg.rightAnchor, constant: 16),
            siretLbl.rightAnchor.constraint(equalTo: headerContainerView.rightAnchor, constant: -pading),
        ])
        
    }
}

fileprivate extension UILabel {
    func setDetailFont(_ weight: UIFont.Weight, size: CGFloat = 16) {
        self.textColor = .white
        self.textAlignment = .left
        self.font = .systemFont(ofSize: size, weight: weight)
    }
}
