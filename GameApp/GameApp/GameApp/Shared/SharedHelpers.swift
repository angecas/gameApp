//
//  SharedHelpers.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 04/02/2024.
//

import Foundation
import UIKit

class SharedHelpers {
    
    func removeHtmlTagsAndDecodeEntities(from htmlString: String?) -> String? {
        guard let htmlString = htmlString else { return nil }
        guard let data = htmlString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            let plainText = attributedString.string
            return plainText
        } catch {
            print("Error decoding HTML: \(error)")
            return nil
        }
    }
    
    @objc func shakeView(uiView: UIView?) {
        if let uiView = uiView {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
            animation.values = [-10.0, 10.0, -8.0, 8.0, -6.0, 6.0, -4.0, 4.0, 0.0]
            animation.duration = 1
            uiView.layer.add(animation, forKey: "shake")
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }

}
