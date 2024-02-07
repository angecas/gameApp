//
//  HomeScreenCell.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation
import UIKit
import SDWebImage

class GridCell: UICollectionViewCell {
    private var genre: Genre?
    
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
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.subTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        
        overlayView.addSubview(titleLabel)
        overlayView.addSubview(counterLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            counterLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            counterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])

    }
    
    func configure(genre: Genre) {

        imageView.sd_imageIndicator = SDWebImageActivityIndicator.white

        imageView.sd_setImage(with: URL(string: genre.imageBackground))
        
        titleLabel.text = genre.name
        if genre.gamesCount > 0 {
            counterLabel.text = genre.gamesCount == 1 ? "\(genre.gamesCount) game" : "\(genre.gamesCount) games"
        }
    }   
    
//    func configure(game: Game) {
//
//        imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
//
//        imageView.sd_setImage(with: URL(string: game.background_image ?? ""))
//        
//        titleLabel.text = game.name
//        counterLabel.text = ""
//    }
}
