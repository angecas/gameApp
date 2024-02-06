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


private let signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle("Sign up!", for: .normal)
    button.titleLabel?.font = Font.boldSubTitleFont
    button.setTitleColor(Color.darkBlue, for: .normal)
    button.backgroundColor = Color.blueishWhite
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()
