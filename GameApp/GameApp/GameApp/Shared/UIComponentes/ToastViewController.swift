//
//  ToastViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 08/02/2024.
//

import UIKit

class ToastViewController: UIViewController {

    let toastLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

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
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    func showToast(message: String) {
        toastLabel.text = message
        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
            self.toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseIn, animations: {
                self.toastLabel.alpha = 0.0
            })
        }
    }
}
