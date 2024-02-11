//
//  LightUIButtonView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 06/02/2024.
//

import UIKit

class LightUIButtonView: UIButton {
    
    init(buttonText: String) {
        super.init(frame: .zero)
        configureUI(buttonText: buttonText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureUI(buttonText: String) {
        self.setTitle(buttonText, for: .normal)
        self.titleLabel?.font = Font.boldSubTitleFont
        self.setTitleColor(Color.darkBlue, for: .normal)
        self.backgroundColor = Color.blueishWhite
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

