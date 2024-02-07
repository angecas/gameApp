//
//  LoginViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import UIKit

class LoginViewController: UIViewController {
    private let loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gamecontroller.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let emailTextField: UITextFieldView = UITextFieldView(placeholder: "Email")
    
    private let passwordTextField: UITextFieldView =  UITextFieldView(placeholder: "Password", isSecured: true)
    
    private let loginButton: LightUIButtonView = LightUIButtonView(buttonText: "Login")
    
    private let createAccountLabel: UILabel = {
        let label = UILabel()
        var mutableString = NSMutableAttributedString(string: "Don't have an account yet? Sign up", attributes: [NSAttributedString.Key.font: Font.bodyFont!, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:27,length:7))
        label.attributedText = mutableString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shakeIcon))
        loginImageView.addGestureRecognizer(tapGesture)
        
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSignUp))
        createAccountLabel.addGestureRecognizer(labelTapGesture)
        
        let loginTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLogin))
        loginButton.addGestureRecognizer(loginTapGesture)
        

        view.addSubview(loginImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(createAccountLabel)
        view.addSubview(loginButton)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        NSLayoutConstraint.activate([
            loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            loginImageView.widthAnchor.constraint(equalToConstant: 94),
            loginImageView.heightAnchor.constraint(equalToConstant: 94),
            
            emailTextField.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 36),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 36),
            
            createAccountLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createAccountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: 32),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    @objc private func shakeIcon() {
        SharedHelpers().shakeView(uiView: loginImageView)
    }  
    
    @objc private func tapLogin() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService().login(email: email, password: password) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("login in")
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc private func tapSignUp() {
        let signupViewController = SignupViewController()
           navigationController?.pushViewController(signupViewController, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            print("finished email")
        } else {
            print("finished pass")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == emailTextField, let text = textField.text {
            print("finished email")
            if SharedHelpers().isValidEmail( text) {
                emailTextField.layer.borderWidth = 2
                emailTextField.layer.borderColor = UIColor.red.cgColor
            }
        } else {
            if let text = textField.text {
                if SharedHelpers().isValidPassword(text) {
                    passwordTextField.layer.borderWidth = 2
                    passwordTextField.layer.borderColor = UIColor.red.cgColor
                }
            }
        }
        return true
    }
}
