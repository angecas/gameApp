//
//  SignupViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 06/02/2024.
//
import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = Font.boldLargeTitleFont
        label.textColor = Color.blueishWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your credentials."
        label.font = Font.boldbodyFont
        label.textColor = Color.blueishWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: LightUIButtonView = LightUIButtonView(buttonText: "Sign up!")

    private let emailTextField: UITextFieldView = UITextFieldView(placeholder: "Email")
    
    private let passwordTextField: UITextFieldView =  UITextFieldView(placeholder: "Password", isSecured: true)
    
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

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),

            emailTextField.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 36),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 36),
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            signUpButton.widthAnchor.constraint(equalToConstant: 100),
            signUpButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    @objc func tapSignup() {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService().registerUser(email: email, password: password) { error in
                if let error = error {
                    print("Registration failed: \(error.localizedDescription)")
                } else {
                    print("User registered successfully")
                    DispatchQueue.main.async {
                        let navigationController = UINavigationController(rootViewController: GenresViewController())
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true)
                    }
                }
            }
        }
    }
}
