//
//  GamesDescriptionHeaderView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 04/02/2024.
//

import UIKit

class GamesDescriptionHeaderView: UIView {
    private var showMore: Bool = false
    
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
//        label.numberOfLines = self.showMore ? 0 : 5

        return text
    }()
    
    private lazy var toggleGamesInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal

        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    
    private lazy var toggleTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldbodyFont
        label.textColor = Color.blueishWhite
        label.text = NSLocalizedString("show-more", comment: "")
        
        return label
    }()
    
    private lazy var toggleTextImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "chevron.compact.down")?.withRenderingMode(.alwaysTemplate)
        return image
    }()


    // MARK: inits
    init() {
        super.init(frame: CGRectZero)
        configureUI()
    }
    
    private func configureUI() {
        addSubview(gamesInfo)
        addSubview(toggleGamesInfoStackView)

        toggleGamesInfoStackView.addArrangedSubview(toggleTextLabel)
        toggleGamesInfoStackView.addArrangedSubview(toggleTextImageView)
        toggleGamesInfoStackView.setCustomSpacing(2, after: toggleTextLabel)
        
        toggleGamesInfoStackView.isHidden = true
        let toggleTap = UITapGestureRecognizer(target: self, action: #selector(toggleTapAction))
        toggleGamesInfoStackView.addGestureRecognizer(toggleTap)
        
        
        NSLayoutConstraint.activate([
            gamesInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            gamesInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            gamesInfo.topAnchor.constraint(equalTo: self.topAnchor),
            gamesInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            toggleGamesInfoStackView.topAnchor.constraint(equalTo: gamesInfo.bottomAnchor, constant: 16),
            toggleGamesInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleTapAction() {
        self.showMore.toggle()

        gamesInfo.textContainer.maximumNumberOfLines = showMore ? 0 : 3
        
        toggleTextLabel.text = showMore ? NSLocalizedString("show-more", comment: "") : NSLocalizedString("show-less", comment: "")
        
        toggleTextImageView.image = showMore ? UIImage(systemName: "chevron.compact.down")?.withRenderingMode(.alwaysTemplate) : UIImage(systemName: "chevron.compact.up")?.withRenderingMode(.alwaysTemplate)
        
        //fazer o reload data

//
//        self.delegate?.didToggleDescriptionShowMore(self, scrollYOffset: eventBodyLabel.frame.origin.y)

    }

    
    func setContent(with text: String) {
        
        gamesInfo.text = text
        gamesInfo.font = Font.subTitleFont
        gamesInfo.textColor = Color.blueishWhite
        
        if let labelText = gamesInfo.text {
            
            let size = (labelText as NSString).boundingRect(with: CGSize(width: gamesInfo.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: gamesInfo.font!], context: nil)
            
            let sizeThatFits = gamesInfo.sizeThatFits(CGSize(width: gamesInfo.frame.width, height: CGFloat.greatestFiniteMagnitude))
            
            if size.height > sizeThatFits.height {
                toggleGamesInfoStackView.isHidden = false
            }
        }
    }
}
