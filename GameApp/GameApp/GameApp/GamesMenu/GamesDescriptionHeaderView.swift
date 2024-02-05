//
//  GamesDescriptionHeaderView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 04/02/2024.
//

import UIKit
protocol GamesDescriptionHeaderViewDelegate {
    func didToggleShowMore(_ view: GamesDescriptionHeaderView)
}

class GamesDescriptionHeaderView: UIView {
    var delegate: GamesDescriptionHeaderViewDelegate?
    
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
//        let toggleTap = UITapGestureRecognizer(target: self, action: #selector(toggleTapAction))
//        text.addGestureRecognizer(toggleTap)
        return text
    }()
    
    private lazy var toggleTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldbodyFont
        label.textColor = Color.blueishWhite
        label.isUserInteractionEnabled = true
        label.text = NSLocalizedString("show-more", comment: "")
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    // MARK: inits
    init() {
        super.init(frame: CGRectZero)
        configureUI()
    }
    
    func calculateHeaderSize() -> CGSize {
         let headerView = GamesDescriptionHeaderView()
         headerView.setContent(with: "Your Header Content")

         let width = UIScreen.main.bounds.width
         let size = headerView.systemLayoutSizeFitting(
             CGSize(width: width, height: UIView.layoutFittingExpandedSize.height),
             withHorizontalFittingPriority: .required,
             verticalFittingPriority: .fittingSizeLevel
         )

         return size
     }
    
    private func updateSize() {
        let width = UIScreen.main.bounds.width
        let height: CGFloat

        if showMore {
            height = gamesInfo.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        } else {
            gamesInfo.textContainer.maximumNumberOfLines = 3
            height = gamesInfo.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        }

        print("Updated height: \(height)")
        frame.size.height = height
    }

    
    private func configureUI() {
        backgroundColor = .red
        addSubview(gamesInfo)
        addSubview(toggleTextLabel)
        toggleTextLabel.isUserInteractionEnabled = true
        
        toggleTextLabel.isUserInteractionEnabled = true

        
        let toggleTap = UITapGestureRecognizer(target: self, action: #selector(toggleTapAction))

        toggleTextLabel.addGestureRecognizer(toggleTap)
        heightConstraint = 
            heightAnchor.constraint(equalToConstant: 900)
           heightConstraint.isActive = true

        
        NSLayoutConstraint.activate([
            gamesInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            gamesInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            gamesInfo.topAnchor.constraint(equalTo: self.topAnchor),
            gamesInfo.bottomAnchor.constraint(equalTo: toggleTextLabel.topAnchor, constant: -16),
            
            toggleTextLabel.topAnchor.constraint(equalTo: gamesInfo.bottomAnchor, constant: 8),
            toggleTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            toggleTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            toggleTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleTapAction() {
        print("oioi")
        self.showMore.toggle()

        gamesInfo.textContainer.maximumNumberOfLines = showMore ? 0 : 3
        
        updateSize()
        
        heightConstraint.constant = showMore ? 900 : 400
        updateConstraints()
                                
        toggleTextLabel.text = showMore ? NSLocalizedString("show-more", comment: "") : NSLocalizedString("show-less", comment: "")
        
//toggle image
//        toggleTextImageView.image = showMore ? UIImage(systemName: "chevron.compact.down")?.withRenderingMode(.alwaysTemplate) : UIImage(systemName: "chevron.compact.up")?.withRenderingMode(.alwaysTemplate)
        
//fazer o reload data

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
            
            if size.height > sizeThatFits.height {
                toggleTextLabel.isHidden = false
            }
            
            updateConstraints()

        }
    }
}
