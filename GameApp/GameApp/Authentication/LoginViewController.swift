//
//  LoginViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties

    private lazy var loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gamecontroller.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let emailTextField: UITextFieldView = UITextFieldView(placeholder: NSLocalizedString("email", comment: ""))
    
    private let passwordTextField: UITextFieldView =  UITextFieldView(placeholder: NSLocalizedString("password", comment: ""), isSecured: true)
    
    private let loginButton: LightUIButtonView = LightUIButtonView(buttonText: NSLocalizedString("login", comment: ""))
    
    private lazy var createAccountLabel: UILabel = {
        let label = UILabel()
        var mutableString = NSMutableAttributedString(string: NSLocalizedString("dont-have-account", comment: ""), attributes: [NSAttributedString.Key.font: Font.subTitleFont!, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:27,length:7))
        label.attributedText = mutableString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helpers

    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shakeIcon))
        loginImageView.addGestureRecognizer(tapGesture)
        
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSignUp))
        createAccountLabel.addGestureRecognizer(labelTapGesture)
                
        loginButton.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

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
            
            emailTextField.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 36),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 36),
            
            createAccountLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createAccountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: 32),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    @objc private func shakeIcon() {
        SharedHelpers().shakeView(uiView: loginImageView)
    }  
    
    private func showRootViewController() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let rootViewController = sceneDelegate.determineRootViewController()
            rootViewController.modalPresentationStyle = .fullScreen
            self.present(rootViewController, animated: true, completion: nil)
        }
    }

    
    @objc private func tapLogin() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService.shared.login(email: email, password: password) { error in
                if let error = error {
                    SharedHelpers().showCustomToast(self, loginMessage: error.localizedDescription)
                } else {
                     DispatchQueue.main.async {
                         self.showRootViewController()
                         
//                         let mainViewController = GenresViewController()
//                         let navigationController = UINavigationController(rootViewController: mainViewController)
//                         
//                         navigationController.modalPresentationStyle = .fullScreen
//                         
//                         self.present(navigationController, animated: true, completion: nil)
                     }
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func tapSignUp() {
        let signupViewController = SignupViewController()
           navigationController?.pushViewController(signupViewController, animated: true)
    }
}
// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
