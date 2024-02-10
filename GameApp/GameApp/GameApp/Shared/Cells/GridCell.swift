//
//  HomeScreenCell.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol GridCellDelegate: AnyObject {
    func updateCell(_ cell: GridCell)
    func showFavoritesErrorToaster(_ cell: GridCell)
}

class GridCell: UICollectionViewCell {
    weak var delegate: GridCellDelegate?
    private var genre: Genre?
    private var genreId: Int?
    
    let favoritesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.red)
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.masksToBounds = true
        imageView.alpha = 0.5
        return imageView
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = Font.bodyFont
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.subTitleFont
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        imageView.image = nil
        genreId = nil
        genre = nil
        favoritesImageView.isHidden = true
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
        
        contentView.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        overlayView.addSubview(favoritesImageView)
        overlayView.addSubview(titleLabel)
        overlayView.addSubview(counterLabel)
        
        NSLayoutConstraint.activate([
            favoritesImageView.topAnchor.constraint(equalTo: overlayView.topAnchor),
            favoritesImageView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            favoritesImageView.widthAnchor.constraint(equalToConstant: 24),
            favoritesImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: overlayView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: overlayView.trailingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            
            counterLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            counterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
    }
    
    func configure(genre: Genre, isFavoriteGenre: Bool = false) {
        favoritesImageView.isHidden = !isFavoriteGenre
        genreId = genre.id
        
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        
        if let imageRemotePath = genre.imageBackground {
            imageView.sd_setImage(with: URL(string: imageRemotePath))
        }
        if let genreName = genre.name, let gameCount =  genre.gamesCount {
            titleLabel.text = genreName
            if gameCount > 0 {
                counterLabel.text = genre.gamesCount == 1 ? "\(gameCount) game" : "\(gameCount) games"
            }
        }
    }
}
