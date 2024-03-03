//
//  UITextFieldView.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 06/02/2024.
//

import UIKit

protocol UITextFieldViewDelegate: AnyObject {
    func didTapRightView(_ view: UITextFieldView)
}

extension UITextFieldViewDelegate {}

class UITextFieldView: UITextField {
    
    weak var delegate2: UITextFieldViewDelegate?
    
    private var isSearch: Bool = false

    init(placeholder: String, isSecured: Bool = false, isSearch: Bool = false) {
        self.isSearch = isSearch
        super.init(frame: .zero)

        configureUI(placeholder: placeholder, isSecured: isSecured, isSearch: isSearch)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configureUI(placeholder: String, isSecured: Bool, isSearch: Bool) {
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
        } else if isSearch {
            let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate).withTintColor(Color.darkBlue))
            searchImageView.tintColor = UIColor.lightGray
            searchImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            searchImageView.contentMode = .center
            searchImageView.isUserInteractionEnabled = true
            self.rightView = searchImageView
            self.rightViewMode = .always
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
            searchImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func togglePasswordVisibility() {
        
        if isSearch {
            delegate2?.didTapRightView(self)
        } else {
            self.isSecureTextEntry.toggle()
            if let eyeImageView = self.rightView as? UIImageView {
                eyeImageView.tintColor = self.isSecureTextEntry ? UIColor.lightGray : Color.darkBlue
            }
        }
    }
}
