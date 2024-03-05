//
//  GameHeaderView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 12/02/2024.
//

import UIKit
import SDWebImage

protocol GameHeaderViewDelegate: NSObject {
    func didShowMore(_ view: GameHeaderView, didShowMore: Bool)
}

class GameHeaderView: UIView {
    
    // MARK: - Props
    weak var delegate: GameHeaderViewDelegate?
    private var headerHeight: CGFloat = 0
    private var pillsContainerView: PillsContainerUIView
    private var pillsContainerHeightConstraint: NSLayoutConstraint!

    private let image: String?
    private var snapshots: [String]
    private var tags: [String]
    private var snapshotCounter = 0
    
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = Color.darkGrey
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - inits
    
    init(image: String?, snapshots: [String], tags: [String]) {
        self.pillsContainerView =  PillsContainerUIView(pillStringsList: tags)
        self.tags = tags
        self.image = image
        self.snapshots = snapshots
        super.init(frame: .zero)
        
        headerImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        headerImage.sd_setImage(with: URL(string: image ?? ""))
                
        setupLayout()
        pillsContainerView.delegate = self

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    private func setupLayout() {
        addSubview(headerImage)
        addSubview(pillsContainerView)
        
        pillsContainerHeightConstraint =
        pillsContainerView.heightAnchor.constraint(equalToConstant: 50)
        pillsContainerHeightConstraint.isActive = true
                
        pillsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: topAnchor),
//            headerImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 200),
            pillsContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pillsContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pillsContainerView.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 8),
        ])
    }
    
    func updateImage() {
        snapshotCounter += 1
        if snapshotCounter < snapshots.count {
            headerImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            headerImage.sd_setImage(with: URL(string: snapshots[snapshotCounter]))
        } else {
            if let image = self.image {
                self.snapshots.insert(image, at: 0)
            }
            snapshotCounter = 0
        }
    }
}

extension GameHeaderView: PillsContainerUIViewDelegate {
    func didTapCell(_ view: PillsContainerUIView) {
        
    }
    
    func didTapShowMore(_ view: PillsContainerUIView, didTapShowMore: Bool) {
        delegate?.didShowMore(self, didShowMore: didTapShowMore)
        
        pillsContainerHeightConstraint.constant = didTapShowMore ? 180 : 50
         
        updateConstraints()

    }
}
