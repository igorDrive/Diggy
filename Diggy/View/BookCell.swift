//
//  BookCell.swift
//  Diggy
//
//  Created by Igor Gorbachov on 5/11/20.
//

import UIKit
import Kingfisher

class BookCell: UITableViewCell {
    
    let bubbleBackgroundView = UIView()
    
    static let cellId = "BookCell"
    
    func configureCell(book: Book) {
        if let url = URL(string: book.bookImage) {
            bookCover.kf.setImage(with: url)
        }
        
        titleLabel.text = book.title
        descriptionLabel.text = book.description
    }
    
    lazy var bookCover: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        
        bubbleBackgroundView.addSubview(bookCover)
        bubbleBackgroundView.addSubview(titleLabel)
        bubbleBackgroundView.addSubview(descriptionLabel)
        
        bookCover.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 0).isActive = true
        bookCover.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor, constant: 16).isActive = true
        bookCover.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8).isActive = true
        bookCover.heightAnchor.constraint(equalToConstant: 230).isActive = true
        bookCover.widthAnchor.constraint(equalToConstant: 120).isActive = true

        titleLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 18).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bookCover.rightAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -16).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: bookCover.rightAnchor, constant: 8).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -16).isActive = true
    }
}
