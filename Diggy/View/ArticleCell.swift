//
//  JobCell.swift
//  Diggy
//
//  Created by Igor Gorbachov on 20/10/20.
//

import UIKit
import Kingfisher

class ArticleCell: UITableViewCell {
    
    let bubbleBackgroundView = UIView()
    
    static let cellId = "JobCell"
    
    func configureCell(article: Article) {
        if let url = URL(string: getImage(media: article.media) ?? "") {
            newsPicture.kf.setImage(with: url)
        }
        
        titleLabel.text = article.title
        descriptionLabel.text = article.abstract
    }
    
    func getImage(media: [Article.Media]) -> String? {
        if let media = media.first {
            return media.metadata[2].url
        } else {
            return nil
        }
    }
    
    lazy var newsPicture: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(bubbleBackgroundView)
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        bubbleBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        bubbleBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        bubbleBackgroundView.addSubview(newsPicture)
        bubbleBackgroundView.addSubview(titleLabel)
        bubbleBackgroundView.addSubview(descriptionLabel)
        
        titleLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -16).isActive = true
        
        newsPicture.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        newsPicture.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor, constant: 16).isActive = true
        newsPicture.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -16).isActive = true
        newsPicture.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: newsPicture.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8).isActive = true
    }
}

