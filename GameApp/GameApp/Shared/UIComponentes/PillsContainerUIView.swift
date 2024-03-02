//
//  PillsContainerUIView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 28/02/2024.
//

import Foundation
import UIKit

protocol PillsContainerUIViewDelegate: AnyObject {
    func didTapCell(_ view: PillsContainerUIView)
    func didTapShowMore(_ view: PillsContainerUIView, didTapShowMore: Bool)
}

class PillsContainerUIView: UIView {
    
    // MARK: - Props
    weak var delegate: PillsContainerUIViewDelegate?

    private var didTapEllipsis: Bool = false
    
    private let pillStringsList: [String]
    
    private lazy var pillsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = true
        collection.isUserInteractionEnabled = true
        collection.backgroundColor = Color.darkBlue
        collection.register(PillViewCollectionCell.self, forCellWithReuseIdentifier: "PillView")
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "ellipsis.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ellipsisTapGesture))
        imageView.addGestureRecognizer(tapGesture)

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Related tags:"
        label.textColor = Color.lightGrey
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var pillsHstack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
                
    // MARK: - inits
    
    init(pillStringsList: [String]) {
        self.pillStringsList = pillStringsList
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    private func setupLayout() {
        
        for stringElement in pillStringsList {
            if pillsHstack.arrangedSubviews.count < 2 {
                let view = PillView(pillsString: stringElement)
                view.heightAnchor.constraint(equalToConstant: 30).isActive = true
                view.widthAnchor.constraint(equalToConstant: 80).isActive = true
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPill))
                
                view.addGestureRecognizer(tapGesture)
                view.translatesAutoresizingMaskIntoConstraints = false
                
                pillsHstack.addArrangedSubview(view)
            }
        }
        let hStack = UIStackView(arrangedSubviews: [
            descriptionLabel,
            pillsHstack,
        ])
        
        if pillStringsList.count > 2 {
            hStack.addArrangedSubview(plusImageView)
            hStack.setCustomSpacing(16, after: pillsHstack)
        }
        
        hStack.setCustomSpacing(16, after: descriptionLabel)

        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        
        addSubview(pillsCollectionView)
        pillsCollectionView.isHidden = true

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            pillsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            pillsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            pillsCollectionView.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 8),
            pillsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            plusImageView.heightAnchor.constraint(equalToConstant: 24),
            plusImageView.widthAnchor.constraint(equalToConstant: 24),
            
        ])
    }
    
    @objc private func ellipsisTapGesture() {
        didTapEllipsis.toggle()
        delegate?.didTapShowMore(self, didTapShowMore: didTapEllipsis)
        
        pillsHstack.isHidden = didTapEllipsis
        
        pillsCollectionView.isHidden = !didTapEllipsis
        
        plusImageView.image = didTapEllipsis ? UIImage(systemName: "xmark.circle.fill") : UIImage(systemName: "ellipsis.circle.fill")
        
    }
    
    @objc private func tapPill() {
        delegate?.didTapCell(self)
    }

    
    private func updateStackViewArrangedSubviews() -> UIStackView {
        
        for stringElement in pillStringsList {
            if pillsHstack.arrangedSubviews.count < 2 {
                let view = PillView(pillsString: stringElement)
                view.heightAnchor.constraint(equalToConstant: 30).isActive = true
                view.widthAnchor.constraint(equalToConstant: 80).isActive = true
                view.translatesAutoresizingMaskIntoConstraints = false
                
                pillsHstack.addArrangedSubview(view)
            }
        }
        let hStack = UIStackView(arrangedSubviews: [
            descriptionLabel,
            pillsHstack,
        ])
        
        if pillStringsList.count > 2 {
            hStack.addArrangedSubview(plusImageView)
            hStack.setCustomSpacing(16, after: pillsHstack)
        }
        
        hStack.setCustomSpacing(16, after: descriptionLabel)

        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        
        addSubview(pillsCollectionView)
        pillsCollectionView.isHidden = true
        
        return hStack
    }
}

extension PillsContainerUIView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pillStringsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PillView", for: indexPath) as? PillViewCollectionCell else {
            fatalError("Failed to dequeue a cell of type CustomImageCell")
            
        }
        cell.configure(pillsString: pillStringsList[indexPath.row])
        
        return cell
    }
}

extension PillsContainerUIView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapPill()
    }
}
extension PillsContainerUIView: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
}
