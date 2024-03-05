//
//  ListCell.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 18/02/2024.
//

import Foundation
import UIKit
import SDWebImage

class ListCell: UITableViewCell {
    private var genre: Genre?
    private var genreId: Int?
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Action"
        label.textColor = Color.blueishWhite
        label.textAlignment = .left
        label.font = Font.subTitleFont
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
    }

    private func setupUI() {
        
        contentView.backgroundColor = Color.darkBlue
        contentView.addSubview(chevronImageView)
        contentView.addSubview(genreLabel)
        
        let stackView = UIStackView(arrangedSubviews: [genreLabel, chevronImageView])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 24),
            chevronImageView.heightAnchor.constraint(equalToConstant: 24),

        ])
    }
    
    func configure(genreName: String) {
        genreLabel.text = genreName
    }
}
