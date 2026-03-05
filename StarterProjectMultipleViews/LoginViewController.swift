//
//  LoginViewController.swift
//  StarterProjectMultipleViews
//
//  Created by Aristo Lo on 4/3/2026.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        let emailPlaceholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .black),
            .foregroundColor: UIColor.lightGray
        ]
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: emailPlaceholderAttributes
        )
        
        passwordTextField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        // 2. Set a custom style for the placeholder specifically
        // This keeps the placeholder Regular weight even though the input is Bold
        let passwordPlaceholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.lightGray
        ]
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: passwordPlaceholderAttributes
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This tells the view to stop editing, which hides the keyboard
        self.view.endEditing(true)
    }
    @IBAction func redirectWebsite(_ sender: Any) {
        let urlString = "https://en.wikipedia.org/wiki/Login"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        
    }
    @IBAction func feedback(_ sender: Any) {
        let urlString = "https://en.wikipedia.org/wiki/Feedback"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
