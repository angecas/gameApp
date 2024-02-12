//
//  GameCell.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 12/02/2024.
//

import UIKit

class GameCell: UITableViewCell {
    // MARK: - Properties
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.lightGrey
        label.font = Font.bodyFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.boldbodyFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    private func setupLayout() {
        
        contentView.backgroundColor = Color.darkGrey
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(infoLabelLabel)
        
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, infoLabelLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(form text: String, with info: String) {
        descriptionLabel.text = text
        infoLabelLabel.text = info
    }
}
