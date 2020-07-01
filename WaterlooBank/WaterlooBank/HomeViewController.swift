//
//  ViewController.swift
//  WaterlooBank
//
//  Created by Jonathan Ellis on 22/06/2015.
//  Copyright (c) 2015 iProov Ltd. All rights reserved.
//

import UIKit
import iProov
import iProovAPIClient
import MBProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet private var usernameTextField: UITextField!

    private let apiClient = APIClient(apiKey: "<Your API Key>", // TODO: Add your API key here
                                      secret: "<Your Secret>")  // TODO: Add your Secret here
    
    private var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Waterloo Bank"
    }
    
    @IBAction private func loginButtonPressed(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else {
            let alert = UIAlertController(title: "Error", message: "Please enter your username/email to login.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        launchIProov(claimType: .verify, username: username)
    }
    
    @IBAction private func registerButtonPressed(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else {
            let alert = UIAlertController(title: "Error", message: "Please enter your username/email to register.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        launchIProov(claimType: .enrol, username: username)
    }
    
    private func launchIProov(claimType: ClaimType, username: String) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Getting token..."
        
        apiClient.getToken(type: claimType, userID: username, success: { (token) in
            
            IProov.launch(token: token, callback: { (status) in
                
                switch status {

                case .connecting:
                    hud.mode = .indeterminate
                    hud.label.text = "Connecting"

                case .connected:
                    break
                    
                case let .processing(progress, message):
                    hud.mode = .determinateHorizontalBar
                    hud.label.text = message
                    hud.progress = Float(progress)
                    
                case let .success(token):
                    
                    hud.hide(animated: true)
                    
                    self.token = token
                    
                    self.performSegue(withIdentifier: "ShowMain", sender: self)
                    self.usernameTextField.text = nil
                    
                case let .failure(reason, feedback):
                    
                    hud.hide(animated: true)
                    
                    let alert = UIAlertController(title: reason, message: feedback, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                        self.launchIProov(claimType: claimType, username: username)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                case .cancelled:
                    
                    hud.hide(animated: true)
                    
                    break
                    
                case let .error(error):
                    hud.hide(animated: true)
                    
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                        self.launchIProov(claimType: claimType, username: username)
                    }))
                    self.present(alert, animated: true, completion: nil)

                @unknown default:
                    break
                    
                }
                
            })
            

        }, failure: { (error) in
            
            hud.hide(animated: true)
            
            let alert = UIAlertController(title: "Failed to get token", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                self.launchIProov(claimType: claimType, username: username)
            }))
            self.present(alert, animated: true, completion: nil)
            
        })

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let accountViewController = segue.destination as? AccountViewController {
            accountViewController.token = self.token
        }
        
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
