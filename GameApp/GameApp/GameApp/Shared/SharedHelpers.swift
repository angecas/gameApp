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
}

class ResultReusableView: UICollectionReusableView {
    
    func configureWithView(_ view: UIView) {
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
