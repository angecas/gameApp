//
//  UITextFieldView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 06/02/2024.
//

import UIKit

class UITextFieldView: UITextField {

    init(placeholder: String, isSecured: Bool = false) {
        super.init(frame: .zero)
        configureUI(placeholder: placeholder, isSecured: isSecured)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configureUI(placeholder: String, isSecured: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isSecureTextEntry = isSecured
        self.placeholder = placeholder
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = Color.blueishWhite.cgColor
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
    }
}
