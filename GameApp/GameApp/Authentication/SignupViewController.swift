//
//  SignupViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 06/02/2024.
//
import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    // MARK: - Properties
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("welcome", comment: "")
        label.font = Font.boldLargeTitleFont
        label.textColor = Color.blueishWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("enter-credentials", comment: "")
        label.font = Font.boldbodyFont
        label.textColor = Color.blueishWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: LightUIButtonView = LightUIButtonView(buttonText: NSLocalizedString("sign-up", comment: ""))

    private let emailTextField: UITextFieldView = UITextFieldView(placeholder: NSLocalizedString("email", comment: ""))
    
    private let passwordTextField: UITextFieldView =  UITextFieldView(placeholder: NSLocalizedString("password", comment: ""), isSecured: true)
    
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
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.backgroundColor = Color.darkBlue
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(signUpLabel)
        stack.addArrangedSubview(signUpDescriptionLabel)

        view.addSubview(stack)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
                
        signUpButton.addTarget(self, action: #selector(tapSignup), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),

            emailTextField.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 36),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 36),
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            signUpButton.widthAnchor.constraint(equalToConstant: 120),
            signUpButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    private func showRootViewController() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let rootViewController = sceneDelegate.determineRootViewController()
            rootViewController.modalPresentationStyle = .fullScreen
            self.present(rootViewController, animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func tapSignup() {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService.shared.registerUser(email: email, password: password) { error in
                if let error = error {
                    SharedHelpers().showCustomToast(self, loginMessage: error.localizedDescription)
                } else {
                    
                    DispatchQueue.main.async {
                        self.showRootViewController()
                        
                    }
                }
            }
        }
    }
}
