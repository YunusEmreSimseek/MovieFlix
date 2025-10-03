//
//  UITextField+Ext.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import Combine
import UIKit

extension UITextField {
    /// A publisher that emits the text of the text field whenever it changes.
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
