//
//  GridCell2.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 07/02/2024.
//
import UIKit
import SDWebImage

class GamesCell: UICollectionViewCell {
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.darkGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gameDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.blueishWhite
        label.font = Font.bodyFont
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.blueishWhite
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Font.boldbodyFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.masksToBounds = true
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        contentView.addSubview(backView)
        backView.addSubview(imageView)
        backView.addSubview(nameLabel)
        backView.addSubview(gameDetailsLabel)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.widthAnchor.constraint(equalToConstant: 100),
            backView.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.topAnchor.constraint(equalTo: backView.topAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            
            gameDetailsLabel.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 4),
            gameDetailsLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            gameDetailsLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
        ])
    }
    
    func showCellDetails() {
        gameDetailsLabel.isHidden.toggle()
    }
    
    func configure(game: Game) {

        imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        imageView.sd_setImage(with: URL(string: game.background_image ?? ""))
        nameLabel.text = game.name
        if let released = game.released {
            gameDetailsLabel.text = NSLocalizedString("released-in", comment: "") + " \(released)"
        }
    }
}
