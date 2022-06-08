//
//  UISearchBar+Extension.swift
//  WeatherApp
//
//  Created by mohammad suhail on 4/6/22.
//

import Foundation
import UIKit

extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            searchTextField.textColor = color
        } else {
            if let textField = getSearchBarTextField() {
                textField.textColor = color
            }
        }

    }
    
    func setTextFieldColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            switch searchBarStyle {
            case .minimal:
                searchTextField.layer.backgroundColor = color.cgColor
                searchTextField.layer.cornerRadius = 6
            case .prominent, .default:
                searchTextField.backgroundColor = color
            default:
                break
            }
        } else {
            if let textField = getViewElement(type: UITextField.self) {
                switch searchBarStyle {
                case .minimal:
                    textField.layer.backgroundColor = color.cgColor
                    textField.layer.cornerRadius = 6
                case .prominent, .default:
                    textField.backgroundColor = color
                default:
                    break
                }
            }
        }

    }
    
    func setPlaceholderTextColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            searchTextField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        } else {
            if let textField = getSearchBarTextField() {
                textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
            }
        }

    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            let button = searchTextField.value(forKey: "clearButton") as! UIButton
            if let image = button.imageView?.image {
                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        } else {
            if let textField = getSearchBarTextField() {
                let button = textField.value(forKey: "clearButton") as! UIButton
                button.setImage(UIImage(named: "clearIcon"), for: .normal)
                button.tintColor = .white
            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            searchTextField.leftView?.tintColor = color
        } else {
            if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
                imageView.image = imageView.image?.transform(withNewColor: color)
            }
        }
    }
    
    func setSearchPlaceholderFont(font: UIFont) {
        if #available(iOS 13.0, *) {
            let placeholderLabel       = searchTextField.value(forKey: "placeholderLabel") as? UILabel
            placeholderLabel?.font     = font
        } else {
            let textFieldInsideUISearchBar = self.value(forKey: "searchField") as? UITextField
            let placeholderLabel       = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        }
        
    }
}
