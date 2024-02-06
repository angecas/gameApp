//
//  LoadingManager.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//

import UIKit

class LoadingManager {

    static let shared = LoadingManager()

    private var loadingView: LoadingView?

    private init() {}

    private var keyWindow: UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }

    func showLoading() {
        guard let keyWindow = keyWindow else {
            return
        }

        loadingView = LoadingView(frame: keyWindow.bounds)
        loadingView?.startAnimating()

        keyWindow.addSubview(loadingView!)
    }

    func hideLoading() {
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
