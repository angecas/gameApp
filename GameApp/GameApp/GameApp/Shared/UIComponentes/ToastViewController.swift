//
//  ToastViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 08/02/2024.
//

import UIKit
//usar para avisar do limite de generos favoritos
//criar lista de generos favoritos, e se tocas neles abre te o genero
class ToastViewController: UIViewController {

    private let toastLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color.blueishWhite
        label.textColor = Color.darkBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    init(message: String) {
        toastLabel.text = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(toastLabel)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    func hideToast() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
            self.dismiss(animated: true)
        })
    }
}
