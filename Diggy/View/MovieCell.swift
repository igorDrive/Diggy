//
//  MovieCell.swift
//  Diggy
//
//  Created by Igor Gorbachov on 13/11/20.
//

import Foundation
import Kingfisher

class MovieCell: UITableViewCell {
    
    let bubbleBackgroundView = UIView()
    
    static let cellId = "MovieCell"
    
    func configureCell(movie: Movie) {
        if let url = URL(string: movie.multimedia?.titleCover ?? "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg") {
            reviewCover.kf.setImage(with: url)
        }

        titleLabel.text = movie.displayTitle ?? "No title"
        descriptionLabel.text = movie.shortSummary
    }
    
//    func getImage(multimedia: Multimedia) -> String? {
//        if let multimedia = multimedia.titleCover {
//            return multimedia
//        } else {
//            return nil
//        }
//    }
    
    lazy var reviewCover: UIImageView = {
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
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        bubbleBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        bubbleBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        bubbleBackgroundView.addSubview(reviewCover)
        bubbleBackgroundView.addSubview(titleLabel)
        bubbleBackgroundView.addSubview(descriptionLabel)
        
        reviewCover.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: -62).isActive = true
        reviewCover.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor, constant: 16).isActive = true
        reviewCover.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: 8).isActive = true
        reviewCover.heightAnchor.constraint(equalToConstant: 230).isActive = true
        reviewCover.widthAnchor.constraint(equalToConstant: 140).isActive = true

//        titleLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: reviewCover.rightAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -16).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: reviewCover.rightAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -16).isActive = true
    }
}
