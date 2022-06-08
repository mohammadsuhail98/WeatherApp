//
//  UIViewController+Extension.swift
//  WeatherApp
//
//  Created by mohammad suhail on 6/6/22.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showHUD(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideHUD(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func presentAlert(title: String, messsage: String, buttonTitle: String? = "Ok", completion:(() -> Void)? = nil){
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            if let completion = completion {
                completion()
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
}
