//
//  JobCell.swift
//  Diggy
//
//  Created by Igor Gorbachov on 20/10/20.
//

import UIKit
import Kingfisher

class JobCell: UITableViewCell {
    
    static let cellId = "JobCell"
    
    func configureCell(job: Job) {
        let url = URL(string: job.companyLogo ?? "")
        logo.kf.setImage(with: url)
        
        titleLabel.text = job.title
        descriptionLabel.attributedText = job.description.htmlToAttributedString
    }
    
    lazy var logo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
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
        contentView.addSubview(logo)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        logo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 50).isActive = true

        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true

        descriptionLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
