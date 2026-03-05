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
        //update the emailTextField font
        
        let emailPlaceholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .black),
            .foregroundColor: UIColor.lightGray
            //update the emailTextField placeholder font
        ]
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: emailPlaceholderAttributes
            //update the placeholder string
        )
        
        passwordTextField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        //update the passwordTextField font
        let passwordPlaceholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.lightGray
            //update the passwordTextField placeholder font
        ]
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: passwordPlaceholderAttributes
            //update the placeholder string
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*touches began means the user touches the screen, the (_ touches...) thing after that is required to put in in Xcode */
        self.view.endEditing(true)
        /* self means the main keyboard, end editing true forces the keyboard to close, so everytime the user clicks other place except the keyboard, the keyboard collapses*/
        
    }
    @IBAction func redirectWebsite(_ sender: Any) {
        let urlString = "https://en.wikipedia.org/wiki/Login"
        //website can be changed anytime
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //if let prevents the app from crashing even if this failed
            //turns the urlString string to URL format
            //UIApplication talks to the whole phone's app
            //open url means open in default browser
            //options are for further browsing options like private window, but [:] means no special
            //completion handler means nothing needs to be run after this
        }
        
        
    }
    @IBAction func feedback(_ sender: Any) {
        let urlString = "https://en.wikipedia.org/wiki/Feedback"
        //website can be changed anytime
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //if let prevents the app from crashing even if this failed
            //turns the urlString string to URL format
            //UIApplication talks to the whole phone's app
            //open url means open in default browser
            //options are for further browsing options like private window, but [:] means no special
            //completion handler means nothing needs to be run after this
        }
    }
}
