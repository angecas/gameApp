//
//  GamesDescriptionHeaderView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 04/02/2024.
//

import UIKit

protocol GamesDescriptionHeaderViewDelegate: AnyObject {
    func didToggleShowMore(_ view: GamesDescriptionHeaderView)
}

class GamesDescriptionHeaderView: UIView {
    // MARK: properties
    weak var delegate: GamesDescriptionHeaderViewDelegate?
    private var headerHeight: CGFloat = 0
    private var showMore: Bool = false
    private var heightConstraint: NSLayoutConstraint!

    private lazy var gamesInfo: UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.isEditable = false
        text.textContainer.maximumNumberOfLines = 5
        text.textContainer.lineBreakMode = .byCharWrapping
        text.textAlignment = .left
        text.textContainerInset = .zero
        text.textContainer.lineFragmentPadding = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = Font.subTitleFont
        text.textColor = Color.blueishWhite
        text.backgroundColor = Color.darkBlue
        text.isUserInteractionEnabled = false
        return text
    }()
    
    private lazy var toggleTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldbodyFont
        label.isUserInteractionEnabled = true
        label.text = NSLocalizedString("show-more", comment: "")
        label.textColor = Color.darkBlue
        label.backgroundColor = Color.blueishWhite
        label.layer.cornerRadius = 16
        label.lineBreakMode = .byWordWrapping
        label.isHidden = true
        return label
    }()
    
    // MARK: inits
    init() {
        super.init(frame: CGRectZero)
        configureUI()
    }
    
    func calculateHeaderSize() -> CGSize {
         let headerView = GamesDescriptionHeaderView()
         headerView.setContent(with: "")

         let width = UIScreen.main.bounds.width
         let size = headerView.systemLayoutSizeFitting(
             CGSize(width: width, height: UIView.layoutFittingExpandedSize.height),
             withHorizontalFittingPriority: .required,
             verticalFittingPriority: .fittingSizeLevel
         )

         return size
     }
    
    private func configureUI() {
        addSubview(gamesInfo)
        addSubview(toggleTextLabel)
        toggleTextLabel.isUserInteractionEnabled = true
                
        let toggleTap = UITapGestureRecognizer(target: self, action: #selector(toggleTapAction))

        toggleTextLabel.addGestureRecognizer(toggleTap)
        
        heightConstraint =
        gamesInfo.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.isActive = true

        NSLayoutConstraint.activate([
            gamesInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gamesInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gamesInfo.topAnchor.constraint(equalTo: self.topAnchor),
            heightConstraint,
            
            toggleTextLabel.topAnchor.constraint(equalTo: gamesInfo.bottomAnchor, constant: 8),
            toggleTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toggleTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: helpers

    @objc private func toggleTapAction() {
        self.showMore.toggle()
        gamesInfo.textContainer.maximumNumberOfLines = showMore ? 0 : 3
        heightConstraint.constant = showMore ? self.headerHeight : 60
        updateConstraints()
        toggleTextLabel.text = showMore ? NSLocalizedString("show-less", comment: "") : NSLocalizedString("show-more", comment: "")
        gamesInfo.isScrollEnabled = showMore ? true : false

        toggleTextLabel.textColor = showMore ? Color.blueishWhite : Color.darkBlue
        toggleTextLabel.backgroundColor = showMore ? Color.darkBlue : Color.blueishWhite
        self.delegate?.didToggleShowMore(self)
    }
    
    func setContent(with text: String) {
        gamesInfo.text = text
        gamesInfo.font = Font.subTitleFont
        gamesInfo.textColor = Color.blueishWhite
        gamesInfo.isUserInteractionEnabled = true
        toggleTextLabel.isUserInteractionEnabled = true
        let toggleTap = UITapGestureRecognizer(target: self, action: #selector(toggleTapAction))
        toggleTextLabel.addGestureRecognizer(toggleTap)

        if let labelText = gamesInfo.text {
            
            let size = (labelText as NSString).boundingRect(with: CGSize(width: gamesInfo.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: gamesInfo.font!], context: nil)
            
            let sizeThatFits = gamesInfo.sizeThatFits(CGSize(width: gamesInfo.frame.width, height: CGFloat.greatestFiniteMagnitude))
            
            self.headerHeight = size.height
            
            if size.height > sizeThatFits.height {
                toggleTextLabel.isHidden = false
            }
            updateConstraints()
        }
    }
}
