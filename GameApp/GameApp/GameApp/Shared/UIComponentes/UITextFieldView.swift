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
        self.isSecureTextEntry = isSecured
        self.placeholder = placeholder
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = Color.blueishWhite.cgColor
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.translatesAutoresizingMaskIntoConstraints = false

        if isSecured {
            let eyeImageView = UIImageView(image: UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(Color.darkBlue))
            eyeImageView.tintColor = UIColor.lightGray
            eyeImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            eyeImageView.contentMode = .center
            eyeImageView.isUserInteractionEnabled = true
            self.rightView = eyeImageView
            self.rightViewMode = .always
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
            eyeImageView.addGestureRecognizer(tapGesture)
        }
    }

    @objc private func togglePasswordVisibility() {
        self.isSecureTextEntry.toggle()
        if let eyeImageView = self.rightView as? UIImageView {
            eyeImageView.tintColor = self.isSecureTextEntry ? UIColor.lightGray : Color.darkBlue
        }
    }
}
