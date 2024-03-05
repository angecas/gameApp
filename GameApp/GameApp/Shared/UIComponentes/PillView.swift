//
//  PillView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 29/02/2024.
//

import Foundation
import UIKit

class PillView: UIView {
        
    // MARK: - Props
    
    private lazy var pillContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.darkGrey
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var pillLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.lightGrey
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

        
    // MARK: - inits
    
    init(pillsString: String) {
        super.init(frame: .zero)
        
        self.pillLabel.text = pillsString
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    private func setupLayout() {
        
        addSubview(pillContainerView)
        pillContainerView.addSubview(pillLabel)

        NSLayoutConstraint.activate([
            pillContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            pillContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pillContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pillContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            pillLabel.topAnchor.constraint(equalTo: pillContainerView.topAnchor),
            pillLabel.bottomAnchor.constraint(equalTo: pillContainerView.bottomAnchor),
            pillLabel.leadingAnchor.constraint(equalTo: pillContainerView.leadingAnchor),
            pillLabel.trailingAnchor.constraint(equalTo: pillContainerView.trailingAnchor),

        ])
    }
    
    func setLabelString(pillsString: String) {
        self.pillLabel.text = pillsString
    }
}

