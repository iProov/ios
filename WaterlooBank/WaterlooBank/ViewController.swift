//
//  ViewController.swift
//  WaterlooBank
//
//  Created by Jonathan Ellis on 22/06/2015.
//  Copyright (c) 2015 iProov Ltd. All rights reserved.
//

import UIKit
import iProov

class ViewController: UIViewController, UITextFieldDelegate {
    
    let serviceProvider: String? = nil //TODO: define your API key here

    @IBOutlet var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Waterloo Bank"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if usernameTextField.text?.isEmpty != false {
            let alert = UIAlertController(title: "Error", message: "Please enter your username/email to login.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        login(usernameTextField.text!)
    }
    
    func login(_ username: String) {
        
        guard serviceProvider != nil else{
            let alert = UIAlertController(title: "Missing API key", message: "Please edit serviceProvider in ViewController.swift", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        IProov.verify(withServiceProvider: serviceProvider!, username: username, animated: true) { (result) in
            
            switch result {
            case let .success(token):
                self.performSegue(withIdentifier: "ShowMain", sender: token)
                self.usernameTextField.text = nil
                
            case let .failure(reason):
                let alert = UIAlertController(title: "Login failed", message: reason.reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                    self.login(username)
                }))
                self.present(alert, animated: true, completion: nil)
                
            case let .error(error):
                let alert = UIAlertController(title: "Login failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                    self.login(username)
                }))
                self.present(alert, animated: true, completion: nil)
                
            default: break

            }
            
        }

    }


    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if usernameTextField.text?.isEmpty != false {
            let alert = UIAlertController(title: "Error", message: "Please enter your username/email to register.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        register(usernameTextField.text!)
    }
    
    
    func register(_ username: String) {
        
        guard serviceProvider != nil else{
            let alert = UIAlertController(title: "Missing API key", message: "Please edit serviceProvider in ViewController.swift", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        IProov.enrol(withServiceProvider: serviceProvider!, username: username, animated: true) { (result) in
            
            switch result {
                
            case let .success(token):
                self.performSegue(withIdentifier: "ShowMain", sender: token)
                self.usernameTextField.text = nil
                
            case let .failure(reason):
                
                let alert = UIAlertController(title: "Registration failed", message: reason.reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                    self.register(username)
                }))
                self.present(alert, animated: true, completion: nil)
                
            case let .error(error):
                
                let alert = UIAlertController(title: "Registration failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                    self.register(username)
                }))
                self.present(alert, animated: true, completion: nil)
                
            default: break
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMain" {
            let mainViewController = segue.destination as! MainViewController
            mainViewController.token = sender as! String
        }
    }
}

