//
//  ResultReusableView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 06/02/2024.
//

import UIKit

class ResultReusableView: UICollectionReusableView {
    
    func configureWithView(_ view: UIView) {
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
