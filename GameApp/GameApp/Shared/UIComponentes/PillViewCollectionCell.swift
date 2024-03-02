//
//  PillViewCollectionCell.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 02/03/2024.
//

import Foundation
import UIKit

class PillViewCollectionCell: UICollectionViewCell {    
    static let reuseIdentifier = "PillView"

    let pillView = PillView(pillsString: "ola")

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
       
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(pillView)

        pillView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pillView.topAnchor.constraint(equalTo: topAnchor),
            pillView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pillView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pillView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configure(pillsString: String) {
        pillView.setLabelString(pillsString: pillsString)
    }
}
